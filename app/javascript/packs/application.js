// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"

document.addEventListener('turbolinks:load', () => {
  var rootEl = document.documentElement;
  const $modalLaunchers = document.querySelectorAll('html:not(.is-clipped) [data-modal]');

  if ($modalLaunchers.length > 0) {
    $modalLaunchers.forEach( el => {
      el.addEventListener('click', (e) => {
        const target = el.dataset.modal
        const $target = document.getElementById(target)

        mixpanel.track('open-modal: ' + target)

        $target.classList.toggle('is-active');
        rootEl.classList.add('is-clipped');
        e.preventDefault();
      })
    })
  }

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {

        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      });
    });
  }

  // Notifications
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    $notification = $delete.parentNode;
    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });

  var $modals = getAll('.modal');
  var $modalButtons = getAll('.modal-button');
  var $modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button');

  if ($modalButtons.length > 0) {
    $modalButtons.forEach(function ($el) {
      $el.addEventListener('click', function () {
        var target = $el.dataset.target;
        var $target = document.getElementById(target);
        rootEl.classList.add('is-clipped');
        $target.classList.add('is-active');
      });
    });
  }

  if ($modalCloses.length > 0) {
    $modalCloses.forEach(function ($el) {
      $el.addEventListener('click', function () {
        closeModals();
      });
    });
  }

  document.addEventListener('keydown', function (event) {
    var e = event || window.event;
    if (e.keyCode === 27) {
      closeModals();
    }
  });

  function closeModals() {
    let modal = document.querySelector('.modal.is-active').id

    rootEl.classList.remove('is-clipped');
    mixpanel.track("close-modal " + modal)
    $modals.forEach(function ($el) {
      $el.classList.remove('is-active');
    });
  }

  // Functions

  function getAll(selector) {
    return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
  }

  let params = new URLSearchParams(window.location.search);

  if (params.has('upgrade-modal')) {
    document.querySelector('[data-modal="upgrade-modal"]').click()
  }
});
