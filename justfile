set dotenv-load

# Use an auto generated image version suffix (based on date) if one is not provided
export IMAGE_VERSION_SUFFIX := env_var_or_default("IMAGE_VERSION_SUFFIX", "_" + `date +%Y%m%d.%H%M`)

# Generate a build version
generate-version:
    @echo "{{IMAGE_VERSION_SUFFIX}}"

# Clean temp build folder
clean:
    @echo "Cleaning tmp folder"
    rm -rf build/tmp

# Update project lock file to lock to specific commit per layer
# You need to run this if you are working on a branch and would like up-to-date
# changes
update-lock file *args="":
    python3 -m kas dump --update --lock {{args}} {{file}} --inplace

# Update the lock file used by the main demo (convinience task)
update-demo-lock *args="":
    just update-lock ./projects/demo.yaml {{args}}

# Build project from a given file
build-project file *args="":
    python3 -m kas build {{file}} {{args}}

# Run custom bitbake command with a given project
bitbake file *args="":
    python3 -m kas shell {{file}} -c 'bitbake {{args}}'

# Build demo
build-demo *args="":
    python3 -m kas build ./projects/demo.yaml {{args}}

# Publish image to Cumulocity IoT (requires go-c8y-cli to be installed)
publish *args="":
    {{justfile_directory()}}/scripts/publish-c8y.sh {{args}}

runqemu config="./projects/demo.yaml":
    kas shell {{config}} -c 'runqemu'
