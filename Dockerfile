# Use an official Flutter image as a parent image
FROM cirrusci/flutter:stable

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Get dependencies
RUN flutter pub get

# Build the app
RUN flutter build apk --release

# Set the default command to run the app
CMD ["flutter", "run", "--release"]
