"""MkDocs hooks for content processing."""

import re
from pathlib import Path


def transform_content(content: str, base_path: str, is_readme: bool = False) -> str:
    """Transform markdown content for mkdocs compatibility.

    Args:
        content: The markdown content to transform
        base_path: The base path of the documentation
        is_readme: Whether the content is from README.md
    """
    # Repository root files (like .gitea/*)
    content = re.sub(
        r"\[([^\]]+)\]\((\.\.\/)*\.gitea\/([^\)]+)\)",
        r"[\1](https://git.cluster.helixon.com/Project-Group/MosaicPipe/src/branch/main/.gitea/\3)",
        content,
    )

    # Source code files
    content = re.sub(
        r"\[([^\]]+)\]\((\.\/|\.\.\/)*src\/([^\)]+)\)",
        r"[\1](https://git.cluster.helixon.com/Project-Group/MosaicPipe/src/branch/main/src/\3)",
        content,
    )

    if is_readme:
        # Handle ./docs/ links in README
        content = re.sub(
            r"\[([^\]]+)\]\(\.\/docs\/([^\)]+)\)",
            r"[\1](\2)",
            content,
        )
    else:
        # Doc to doc links (keep relative but fix path)
        content = re.sub(
            r"\[([^\]]+)\]\(\.\/([^\)]+)\)",
            r"[\1](\2)",
            content,
        )
        # Handle relative path links (../docs/...)
        content = re.sub(
            r"\[([^\]]+)\]\((\.\.\/)+docs\/([^\)]+)\)",
            r"[\1](\3)",
            content,
        )

    return content


def on_page_markdown(markdown: str, page, config, files):
    """Hook for modifying markdown content before rendering."""
    # Check if this is the README.md content
    is_readme = page.file.src_path == "index.md"

    # If it's index.md, load and transform README.md content
    if is_readme:
        readme_path = Path(config["docs_dir"]).parent / "README.md"
        if readme_path.exists():
            with readme_path.open("r", encoding="utf-8") as f:
                markdown = f.read()

    return transform_content(markdown, config["docs_dir"], is_readme)