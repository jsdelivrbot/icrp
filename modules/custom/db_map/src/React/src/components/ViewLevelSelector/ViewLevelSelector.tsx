import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { LocationFilters, getRegionFromId, getCountryFromAbbreviation, ViewLevel } from '../../services/DataService';
import './ViewLevelSelector.css';

interface ViewLevelTag {
  label: string;
  locationFilters: LocationFilters;
}

interface ViewLevelSelectorProps {
  onSelect: (LocationFilters: LocationFilters) => void;
}

interface ViewLevelSelectorState {
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
}

export default class ViewLevelSelector extends ComponentBase<ViewLevelSelectorProps & React.Props<any>, ViewLevelSelectorState> {

  _buildState(): ViewLevelSelectorState {

    return {
      locationFilters: store.getLocationFilters(),
      viewLevel: store.getViewLevel(),
    };
  }

  buildTags(): ViewLevelTag[] {
    let { viewLevel } = this.state;
    let locationFiltersRef = this.state.locationFilters;
    let locationFilters = {...locationFiltersRef};

    let allRegionsFilters: LocationFilters = {
      ...locationFilters,
      type: 'regions',
    };

    delete allRegionsFilters.region;
    delete allRegionsFilters.country;
    delete allRegionsFilters.city;
    delete allRegionsFilters.institution;

    const viewLevelTags: ViewLevelTag[] = [
      {
        label: 'All Regions',
        locationFilters: allRegionsFilters,
      }
    ];

    if (locationFilters.region  && viewLevel != 'regions') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'countries',
      };

      delete regionFilter.country;
      delete regionFilter.city;
      delete regionFilter.institution;

      viewLevelTags.push({
        label: getRegionFromId(locationFilters.region),
        locationFilters: regionFilter,
      })
    }


    if (locationFilters.country && viewLevel != 'regions' && viewLevel != 'countries') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'cities',
      };

      delete regionFilter.city;
      delete regionFilter.institution;

      viewLevelTags.push({
        label: getCountryFromAbbreviation(locationFilters.country || 'Country'),
        locationFilters: regionFilter,
      })
    }

    if (locationFilters.city && viewLevel != 'regions' && viewLevel != 'countries' && viewLevel != 'cities') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'institutions',
      };

      delete regionFilter.institution;

      viewLevelTags.push({
        label: locationFilters.city || 'City',
        locationFilters: regionFilter,
      })
    }



    return viewLevelTags
  }

  render() {
    let { onSelect } = this.props;


    return (
      <div className="display-flex align-items-center position-relative">
      {
        this.buildTags().map((tag, index) =>
          <span key={index} className="position-relative">
            <div className="bg-chevron" onClick={event => onSelect(tag.locationFilters)}>
              {tag.label}
            </div>
          </span>
        )
      }
      </div>
    )
  }
}