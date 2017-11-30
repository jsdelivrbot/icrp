import { Component, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { SharedDataService } from '../../../../services/shared-data.service';
import { DataUploadService } from '../../../../services/data-upload.service';

@Component({
  selector: 'data-import-page',
  templateUrl: './import-page.component.html',
  styleUrls: ['./import-page.component.css']
})
export class ImportPageComponent {

  alerts: {type: string, message: string}[] = [];
  
  form: FormGroup;

  @Output() previous: EventEmitter<any> = new EventEmitter();

  @Output() cancel: EventEmitter<any> = new EventEmitter();

  // @Output() submit: EventEmitter<any> = new EventEmitter();

  constructor(
    private formBuilder: FormBuilder,
    private sharedData: SharedDataService,
    private dataUpload: DataUploadService
  ) {
    this.form = formBuilder.group({
      fundingYearStart: [2016, Validators.required],
      fundingYearEnd: [2016, Validators.required],
      importNotes: [null, Validators.required],
    });

    let {fundingYearStart, fundingYearEnd} = this.form.controls;

    fundingYearEnd.valueChanges.subscribe(value => {
      fundingYearStart.setValidators([
        Validators.required, 
        Validators.max(value)
      ]);

      fundingYearStart.updateValueAndValidity();
    });
 }

 submit() {

  this.alerts = [];
  
  let {
    fundingYearStart, 
    fundingYearEnd, 
    importNotes
  } = this.form.controls;


  this.sharedData.merge({
    loading: true
  });  

  this.dataUpload.importProjects({
    type: this.sharedData.get('uploadType'),
    fundingYears: [
      fundingYearStart.value, 
      fundingYearEnd.value,
    ].join('-'),
    importNotes: importNotes.value,
    partnerCode: this.sharedData.get('sponsorCode'),
    receivedDate: this.sharedData.get('submissionDate'),
  }).subscribe(
    response => {
      this.alerts.push({
        type: 'success',
        message: 'The following records have been successfully imported to staging. Please use the <a href="/data-upload-review">Data Review Tool</a> to review the imported data.',
      });
      
      this.sharedData.merge({
        loading: false,
      })
    },

    // handle errors
    ({error}) => {
      this.alerts.push({
        type: 'danger',
        message: error,
      });

      this.sharedData.merge({
        loading: false
      });
    }
  )

   
 }

 




}
