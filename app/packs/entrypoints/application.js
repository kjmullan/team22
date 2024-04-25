import $ from 'jquery';
import Rails from "@rails/ujs";
import "bootstrap";
import initMediaPreview from "../scripts/media_preview";

Rails.start();
initMediaPreview();