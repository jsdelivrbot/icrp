import React from 'react';
import FundingOrganizationForm from '../FundingOrganizationForm/';

export default class Form extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      form: {
        partner: '',
        memberType: '',
        name: '',
        abbreviation: '',
        organizationType: '',
        annualizedFunding: false,
        country: '',
        currency: '',
        note: '',
      },
      fields: {
        organizationTypes: [
          'Government',
          'Non-profit',
          'Other',
        ],
        partners: [],
        countries: [],
        currencies: [],
      },
      validation: {

      },
      loading: true,
      message: {
        
      }
    };

    this.getFields();
  }

  async getFields() {

    let hostname = window.location.hostname;
    let endpoint = `http://${hostname}/api/admin/funding_organizations/fields`;
    let response = await fetch(endpoint);
    let data = await response.json()

    let fields = this.state.fields;
    for (let key in data) {
      fields[key] = data[key];
    }

    this.setState({
      fields: fields,
      loading: false,
    });
  }

  handleChange(field, value) {
    let formState = this.state.form;
    formState[field] = value;

    if (['partner', 'memberType'].indexOf(field) > -1
      && formState.partner
      && formState.memberType === 'Partner') {

      console.log(formState);
      let partner = this.state.fields.partners.find(e => e.value === formState.partner)
      formState.name = partner.label;
      formState.country = partner.country;
      formState.currency = partner.currency;
    }

    if (field === 'country') {
      let country = this.state.fields.countries.find(e => e.value === value);
      formState.currency = country.currency;
    }

    this.setState({
      form: formState
    });
  }

  validate() {
    let formState = this.state.form;
    let validationState = {};
    let valid = true;
    let requiredFields = [
      'partner',
      'memberType',
      'name',
      'abbreviation',
      'organizationType',
      'country',
      'currency',
    ];

    for (let field of requiredFields) {
      if (!formState[field]) {
        validationState[field] = false;
        valid = false;
      }
    }

    this.setState({
      validation: validationState
    })
    
    return valid;
  }

  async submit() {
    let isValid = this.validate();

    if (isValid) {
      let form = this.state.form;
      let formData = new FormData();
      let parameterMap = {
        partner: 'sponsor_code',
        memberType: 'member_type',
        name: 'organization_name',
        abbreviation: 'organization_abbreviation',
        organizationType: 'organization_type',
        annualizedFunding: 'is_annualized',
        country: 'country',
        currency: 'currency',
        note: 'note',
      };

      for (let key in form) {
        let formKey = parameterMap[key];
        let formValue = form[key];
        formData.set(formKey, formValue);
      }
      
      let hostname = window.location.hostname;
      let endpoint = `http:///${hostname}/api/admin/funding_organizations/add`;

      let response = await fetch(endpoint, {
        method: 'POST',
        body: formData,
      });

      let messages = await response.json();
      let statusMessage = messages.pop();

      this.setState({
        message: statusMessage
      })
    }
  }

  dismissMessage() {
    this.setState({
      message: {}
    })
  }

  clear() {
    this.setState({
      form: {
        partner: '',
        memberType: '',
        name: '',
        abbreviation: '',
        organizationType: '',
        annualizedFunding: '',
        country: '',
        currency: '',
        note: '',
      },
      validation: {},

    })
  }

  async getFormFields() {
    let response = await fetch(`${this.props.endpoint}/api/admin/add_funding_organization/fields`);
    let fields = await response.json();

    this.setState({
      fields: fields
    });
  }


  render() {
    return <FundingOrganizationForm
      form={ this.state.form }
      fields={ this.state.fields }
      validation={ this.state.validation }
      changeCallback={ this.handleChange.bind(this) }
      submitCallback={ this.submit.bind(this) }
      cancelCallback={ this.clear.bind(this) }
      loading={ this.state.loading }
      message={ this.state.message }
      dismissMessage={ this.dismissMessage.bind(this) }
    />
  }
}
