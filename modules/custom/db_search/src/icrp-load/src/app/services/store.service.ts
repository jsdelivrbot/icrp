import { Injectable } from '@angular/core';

@Injectable()
export class StoreService {

  private fallbackStore: any = {};
  private storageType: 'localStorage' | 'sessionStorage' = 'localStorage';

  get(key: string) {
    let storageType = this.storageType;

    if (this.storageAvailable(storageType)) {
      return JSON.parse(window[storageType][key]);
    } else {
      return this.fallbackStore[key];
    }
  }

  set(key: string, value: any) {
    let storageType = this.storageType;

    if (this.storageAvailable(storageType)) {
      window[storageType][key] = JSON.stringify(value);
    } else {
      this.fallbackStore[key] = value;
    }
  }

  exists(key: string) {
    let storageType = this.storageType;

    if (this.storageAvailable(storageType)) {
      return window[storageType][key] != null && window[storageType][key] != undefined;
    } else {
      return this.fallbackStore[key] != null && this.fallbackStore[key] != undefined;
    }
  }

  private storageAvailable(type) {

    let storage = undefined;

    try {
      storage = window[type];

      let x = '__storage_test__';
      storage.setItem(x, x);
      storage.removeItem(x);
      return true;
    }
    catch(e) {
      return e instanceof DOMException && (
        // everything except Firefox
        e.code === 22 ||
        // Firefox
        e.code === 1014 ||
        // test name field too, because code might not be present
        // everything except Firefox
        e.name === 'QuotaExceededError' ||
        // Firefox
        e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
        // acknowledge QuotaExceededError only if there's something already stored
        storage.length !== 0;
    }
  }

}
