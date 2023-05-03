class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateTaskException extends CloudStorageException {}

class CouldNotGetAllTasksException extends CloudStorageException {}

class CouldNotUpdateTaskException extends CloudStorageException {}

class CouldNotDeleteTaskException extends CloudStorageException {}

class CouldNotGetSpecificTaskException extends CloudStorageException {}
