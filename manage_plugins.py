from typing import Dict
import yaml
from os import path
import requests
import zipfile
import shutil
import tempfile
from concurrent import futures
from functools import partial
import click
import re

my_plugins = "plugins.yaml"
GITHUB_ZIP = "%s/archive/master.zip"


@click.group()
def cli():
    pass


def _parse_plugins(file_name: str = "plugins.yaml") -> Dict:
    try:
        with open(file_name, "r") as fh:
            plugins_dict = yaml.load(fh, Loader=yaml.FullLoader)
            return plugins_dict
    except Exception:
        exit

def _append_plugins_list(dest_dir: str, plugin_name: str, plugin_url: str, file_name:str = "plugins.yaml"):
    plugins_dict = _parse_plugins(file_name)
    if dest_dir not in plugins_dict:
        plugins_dict[dest_dir] = []
    plugins_dict[dest_dir].append("{} {}".format(plugin_name, plugin_url))
    with open(file_name, "w") as fh:
        yaml.dump(plugins_dict, fh)


def download_extract_replace(
    plugin_name: str, zip_path: str, temp_dir: str, dest_dir: str
):
    temp_zip_path = path.join(temp_dir, plugin_name)

    # Download and extract file in temp dir
    req = requests.get(zip_path)

    with open(temp_zip_path, "wb") as fh:
        fh.write(req.content)

    zip_f = zipfile.ZipFile(temp_zip_path)
    zip_f.extractall(temp_dir)

    plugin_temp_path = path.join(
        temp_dir,
        path.join(
            temp_dir, "%s-master" % plugin_name
        ),  # extracted folder has format repo_name-master
    )

    # Remove the current plugin and replace it with the extracted
    plugin_dest_path = path.join(dest_dir, plugin_name)

    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass

    shutil.move(plugin_temp_path, plugin_dest_path)


def _update(dest_dir, temp_directory, plugin):
    name, github_url = plugin.split(" ")
    github_url = github_url.replace(".git", "")
    zip_path = GITHUB_ZIP % github_url
    download_extract_replace(name, zip_path, temp_directory, dest_dir)
    print("Updated {0}".format(name))


@cli.command()
def update_all_plugins():

    temp_directory = tempfile.mkdtemp()
    plugins_dict = _parse_plugins("plugins.yaml")

    try:
        with futures.ThreadPoolExecutor(16) as executor:
            for dest_dir, plugin_list in plugins_dict.items():
                _partial_update = partial(_update, dest_dir, temp_directory)
                executor.map(_partial_update, plugin_list)
    finally:
        shutil.rmtree(temp_directory)


@cli.command()
@click.option("--plugin_url", nargs=1, type=str, required=True)
@click.option("--dest_dir", default="my_plugins")
def install(plugin_url, dest_dir):
    try:
        temp_directory = tempfile.mkdtemp()
        plugin_name = plugin_url.replace(".git", "").split("/")[-1]
        zip_path = GITHUB_ZIP % plugin_url.replace(".git", "")
        click.echo("Plugin name: {}".format(plugin_name))
        click.echo("Git zip path:{}".format(zip_path))
        download_extract_replace(plugin_name, zip_path, temp_directory, dest_dir)
        click.echo("installed {}".format(plugin_name))
        _append_plugins_list(dest_dir, plugin_name, plugin_url)
    finally:
        shutil.rmtree(temp_directory)






if __name__ == "__main__":
    cli()
