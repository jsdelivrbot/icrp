import { AfterViewInit, Component, Inject, Input, EventEmitter, OnChanges, OnInit, Output, SimpleChanges } from '@angular/core';
import { Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import { Validators, FormBuilder, FormGroup } from '@angular/forms';

import { Observable } from 'rxjs/Rx';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/catch';

@Component({
  selector: 'export-results-abstracts-partner-button',
  templateUrl: './export-results-abstracts-partner-button.component.html',
  styleUrls: ['./export-results-abstracts-partner-button.component.css']
})
export class ExportResultsAbstractsPartnerButtonComponent implements OnInit {

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http) { }

  ngOnInit() {
  }

downloadResultsWithAbstractPartner(Modal: any){

}

}
