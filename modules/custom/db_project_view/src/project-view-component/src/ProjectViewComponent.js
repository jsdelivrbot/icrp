import React, { Component } from 'react';
import DataTable from './DataTable';
import './ProjectViewComponent.css';

class ProjectViewComponent extends Component {

  /**
   * @typedef apiResults
   * @type {Object}
   * @property {Object[]} project_details Project details 
   * @property {Object[]} project_funding_details Project funding details
   * @property {Object[]} cancer_types Project cancer types
   * @property {Object[]} cso_research_areas Project CSO research areas
   */

  /** @type {apiResults} */
  apiResults = {
    project_details: [
      {
        project_title: null,
        project_start_date: null,
        project_end_date: null,
        technical_abstract: null,
        public_abstract: null,
        funding_mechanism: null,
      }
    ],
    project_funding_details: [
      {
        project_funding_id: null,
        project_title: null,
        pi_last_name: null,
        pi_first_name: null,
        institution: null,
        city: null,
        state: null,
        country: null,
        award_type: null,
        alt_award_code: null,
        funding_organization: null,
        budget_start_date: null,
        budget_end_date: null,
      }
    ],
    cancer_types: [
      {
        cancer_type: null,
        cancer_type_url: null,
      }
    ],
    cso_research_areas: [
      {
        cso_code: null,
        cso_category: null,
        cso_name: null,
        cso_short_name: null
      }
    ]
  }
  
  state = {
    results: null,
    loading: true,
    error: false,
    table: {
      columns: [],
      data: []
    }
  }

  constructor(props) {
    super(props);
    this.updateResults(props.project);
  }

  async updateResults(project) {
    try {
      let endpoint = `/project/get/${project}`;

      if (window.location.hostname === 'localhost') {
        endpoint = `https://icrpartnership-demo.org${endpoint}`;
      }

      let response = await fetch(endpoint);
      
      /** @type {apiResults} */
      let results = await response.json();

      let columns = [
        {
          label: 'Title',
          value: 'project_title',
          link: 'project_funding_url'
        },
        {
          label: 'Category',
          value: 'project_category',
        },
        {
          label: 'Funding Org.',
          value: 'funding_organization',
        },
        {
          label: 'Alt Award Code',
          value: 'alt_award_code',
        },
        {
          label: 'Award Funding Period',
          value: 'award_funding_period',
        },
        {
          label: 'PI',
          value: 'pi_name',
        },
        {
          label: 'Institution',
          value: 'institution',
        },
        {
          label: 'Location',
          value: 'location',
        },
      ];
      
      let data = results.project_funding_details.map(row => ({
        project_title: row.project_title,
        project_funding_url: `/project/funding-details/${row.project_funding_id}`,
        project_category: row.award_type,
        funding_organization: row.funding_organization,
        alt_award_code: row.alt_award_code,
        award_funding_period: (! row.budget_start_date && !row.budget_end_date) 
              ? 'Not specified'
              : (row.budget_start_date || 'N/A') + '-'
              + (row.budget_end_date || 'N/A'),

        pi_name: [row.pi_last_name, row.pi_first_name].filter(e => e.length).join(', '),
        institution: row.institution,
        location: [row.city, row.state, row.country].filter(e => e.length).join(', '),
      }));

      this.setState({
        loading: false,
        results: results,
        table: {
          columns: columns,
          data: data
        }
      });
    }
    catch (exception) {
      this.setState({
        loading: false,
        error: true,
      })
    }
  }
  
  render() {
    return (
      <div className="native-font">
        { ! this.state.loading && <div>

        <h3 className="title margin-right">View Project Details</h3>
        <h4 className="h4 grey">{ this.state.results.project_details[0].project_title }</h4>
        <hr className="less-margins" />

        <dl className="dl-horizontal margin-bottom margin-top">
          <dt>Award Code</dt>
          <dd>{ this.state.results.project_details[0].award_code || 'Not specified' }</dd>

          <dt>Project Dates</dt>
          <dd>
            {
              (! this.state.results.project_details[0].project_start_date && !this.state.results.project_details[0].project_end_date) 
              ? 'Not specified'
              : (this.state.results.project_details[0].project_start_date || 'N/A') + '-'
              + (this.state.results.project_details[0].project_end_date || 'N/A') 
            }
          </dd>
          <dt>Funding Mechanism</dt>
          <dd>{ this.state.results.project_details[0].funding_mechanism || 'Not specified' }</dd>
        </dl>

        <h5 className="h5 margin-top">Award Funding</h5>

        <DataTable columns={this.state.table.columns} data={this.state.table.data} limit="5"/>

        {this.state.results.project_details[0].technical_abstract && 
          <div>
            <h4>Technical Abstract</h4>
            <div>{ this.state.results.project_details[0].technical_abstract }</div>
            <hr />
          </div>}

        {this.state.results.project_details[0].public_abstract && 
          <div>
            <h4>Public Abstract</h4>
            <div>{ this.state.results.project_details[0].public_abstract }</div>
            <hr />
          </div>}


        <h5 className="h5">Cancer Types</h5>
        <ul>
          {
            this.state.results.cancer_types.map((row, rowIndex) => 
              <li key={rowIndex}>{
                row.cancer_type_url 
                ? <a href={row.cancer_type_url} target="_blank">{row.cancer_type}</a>
                : row.cancer_type
              }</li>
            )
          }
        </ul>

        <h5 className="h5">Common Scientific Outline (CSO) Research Areas</h5>
        <ul>
          {this.state.results.cso_research_areas.map((row, rowIndex) => 
              <li key={rowIndex}><b>{row.cso_code} {row.cso_category}</b> {row.cso_short_name}</li>
            )
          }
        </ul>

        </div>}
      </div>
    );
  }
}

export default ProjectViewComponent;
