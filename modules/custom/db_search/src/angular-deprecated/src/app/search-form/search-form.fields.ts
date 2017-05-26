import { Injectable, Inject } from '@angular/core'
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Injectable()
export class SearchFields {


  constructor(
    private http: Http,
    private apiRoot: string
  ) {
  }
  
  getFields(): Observable<Response> {
    let endpoint = `${this.apiRoot}/db/public/fields`;
    return this.http.get(endpoint)
      .map((response: Response) => response.json())
      .catch((error: Response | any) => Observable.throw(error.json().error || 'Server Error'));
  }
}