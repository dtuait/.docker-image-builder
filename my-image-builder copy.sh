#!/bin/bash


# bash my-image-builder.sh --push-to-hub 'y' --imagepath '__owner__vicre__project__api-security-ait-dtu-dk__image__app-main__tag__python-3.10-bullseye-django-4.2.11-27-03-2024-venv-myversion-1.0.4'

# While there are arguments to process
while [ $# -gt 0 ]; do

    # If the argument starts with "--"
    if [[ $1 == *"--"* ]]
    then
        # Remove the "--" from the argument
        param="${1/--/}"
        # Declare a variable with the name of the argument and assign the next argument as its value
        declare $param="$2"
    fi

    # Shift the positional parameters to the left, discarding the first argument and moving the rest one position to the left
    shift 1
done

# If the 'migrate' parameter is not 'export' or 'import'
if [[ "$migrate" != "filepath" && ]]; then 
    echo "Please specify '--migrate 'export|import''"; 
    exit 1; 
fi



# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 'foldername'"
    exit 1
fi

FOLDER_NAME="$1"

# Navigate to the script's directory
cd "$(dirname "$0")" || exit

echo "Folder name: $FOLDER_NAME"
pwd

if [ ! -d "$FOLDER_NAME" ]; then
    echo "The specified folder does not exist."
    exit 1
fi

cd "./$FOLDER_NAME" || exit

# Extract owner, project, image, and tag from the folder name
# Format: __owner__<owner>__project__<project>__image__<image>__tag__<tag>
# Example: __owner__vicre__project__api-security-ait-dtu-dk__image__app-main__tag__python-3.10-bullseye-django-4.2.11-27-03-2024-venv-myversion-1.0.4

OWNER=$(echo "$FOLDER_NAME" | sed -n 's/.*__owner__\([^_]*\).*/\1/p')
PROJECT=$(echo "$FOLDER_NAME" | sed -n 's/.*__project__\([^_]*\).*/\1/p')
IMAGE=$(echo "$FOLDER_NAME" | sed -n 's/.*__image__\([^_]*\).*/\1/p')
TAG=$(echo "$FOLDER_NAME" | sed -n 's/.*__tag__\([^_]*\).*/\1/p')

# Construct the Docker image name using extracted values
IMAGE_NAME="$OWNER/$PROJECT-$IMAGE"

echo "Building Docker image: $IMAGE_NAME:$TAG..."
docker build -t "$IMAGE_NAME:$TAG" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image $IMAGE_NAME:$TAG successfully built."
else
    echo "Failed to build the Docker image."
    exit 1
fi
