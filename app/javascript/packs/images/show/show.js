import './main.js';
import ShareForm from './share_form'

const shareForm = new ShareForm('#shareModal', '#new_share_email');

shareForm.attachEventHandlers();
