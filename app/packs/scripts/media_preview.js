import $ from 'jquery';

export default function initMediaPreview() {
  let selectedFiles = [];

  $(document).ready(function() {
    $('#media-select-btn').on('click', function() {
      $('#media-input-visual').click(); 
    });

    $('#media-input-visual').on('change', function(event) {

      for (let file of event.target.files) {
        selectedFiles.push(file);
      }
      updateFileInput();
      renderPreviews();
    });

    function renderPreviews() {
      var previewContainer = $('#media-preview-container');
      previewContainer.empty(); // Clear existing previews

      selectedFiles.forEach(function(file, index) {
        var reader = new FileReader();
        reader.onload = function(e) {
          var preview = $('<div class="media-preview"></div>');
          if (file.type.startsWith('image/')) {
            preview.append('<img src="' + e.target.result + '" style="max-width: 200px; max-height: 200px; object-fit: contain;">');
          } else if (file.type.startsWith('video/')) {
            preview.append('<video src="' + e.target.result + '" style="max-width: 200px; max-height: 200px;" controls>');
          } else if (file.type.startsWith('audio/')) {
            preview.append('<audio src="' + e.target.result + '" controls>');
          }
          preview.append('<span class="media-preview-name">' + file.name + '</span>');
          preview.append(`<button type="button" class="btn btn-sm btn-danger media-preview-remove" data-index="${index}">Remove</button>`);
          previewContainer.append(preview);
        };
        reader.readAsDataURL(file);
      });
    }

    // Update the actual file input based on selectedFiles
    function updateFileInput() {
      var dataTransfer = new DataTransfer();
      selectedFiles.forEach(function(file) {
        dataTransfer.items.add(file);
      });
      $('#media-input').prop('files', dataTransfer.files);
    }

    // Handle file removal
    $(document).on('click', '.media-preview-remove', function() {
      const indexToRemove = parseInt($(this).data('index'), 10);
      selectedFiles.splice(indexToRemove, 1); // Remove the file from the selectedFiles array
      updateFileInput(); // Update the file input
      renderPreviews(); // Re-render the previews
    });
  });
}
