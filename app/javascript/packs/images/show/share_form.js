class ShareForm {
  constructor(modalSelector, formSelector) {
    this.$modal = $(modalSelector);
    this.$form = $(formSelector);
  }

  attachEventHandlers() {
    this.$form.on('ajax:success', (ev, res) => {
      this.addFlashMessage(res);
      this.$modal.modal('hide');
    }).on('ajax:error', (ev, res) => {
      const data = res.responseJSON;
      this.addFlashMessage(data.flash);
      this.addErrorMessagesToForm(data.errors);
    });
  }

  addFlashMessage(messages) {
    if(!messages || !messages.length) return;

    let $flashMessages = $('#flash-messages');

    if(!$flashMessages.length) {
      $flashMessages = $('<div id="flash-messages"></div>').insertBefore('.main-content');
    }

    $flashMessages.empty();
    $flashMessages.removeClass('alert-success alert-danger');

    messages.forEach((message) => {
      const messageType = message[0];
      const messageContent = message[1];

      $flashMessages.append( `<div class="alert alert-${messageType}">${messageContent}</div>`);
    })
  }

  addErrorMessagesToForm(errors) {
    for (let field in errors) {
      const fieldName = field[0].toUpperCase() + field.substr(1);
      const $formField = this.$form.find(`.form-group[class*="${field}"]`);
      let $fieldErrors = $formField.find('.invalid-feedback').first();

      if($fieldErrors.length) {
        $fieldErrors.empty();
      } else {
        $fieldErrors = $('<div class="invalid-feedback"></div>').appendTo($formField);
      }

      $formField.find(`input[id*="${field}"]`).addClass('is-invalid');
      $formField.addClass('form-group-invalid');
      const fieldErrors = errors[field].map((el) => `${fieldName} ${el}`).join('. ');
      $fieldErrors.text(fieldErrors);
    }
  }
}

export default ShareForm;
