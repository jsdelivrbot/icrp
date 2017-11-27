import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { FileValidators } from '../../validators/file-validator/file-validator';
import { ImportService, ParseResult } from '../../services/import.service';
import { ExportService } from '../../services/export.service';

@Component({
  selector: 'icrp-import-collaborators',
  templateUrl: './import-collaborators.component.html',
  styleUrls: ['./import-collaborators.component.css'],
  providers: [ImportService, ExportService]
})
export class ImportCollaboratorsComponent {

  form: FormGroup;

  loading: boolean = false;
  error: boolean = false;
  message: string = '';
  records: any[] = [];
  headers: string[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private importService: ImportService,
    private exportService: ExportService
  ) {
    this.form = formBuilder.group({
      file: ['', [
        FileValidators.required,
        FileValidators.pattern(/.csv$/)
      ]]
    });
  }

  async submit() {
    if (!this.form.valid)
      return;

    this.loading = true;
    this.error = false;
    this.message = '';

    const file = this.form.controls.file.value[0] as File;
    const csv = await this.importService.parseCSV(file) as ParseResult;
    const data = csv.data;
    data.shift();

    const response$ = await this.importService.importCollaborators(data);
    response$.subscribe(
      data => {

        // data.imported contains the number of successfully imported records
        if (data.imported !== 0) {
          this.error = false;
          this.message = `${data.imported.toLocaleString()} collaborators have been imported successfully.`;
        }

        else if (data.errors.length > 0) {
          this.error = true;
          // this.message = 'The following records failed the integrity check. The import process has been aborted. Please correct the data file and import again.';
          this.message = 'The following records failed the data check. Import aborted. Please correct the data file and rerun the import.';
          this.records = data.errors;
          this.headers = Object.keys(data.errors[0]);
        }
      },

      ({error}) => {
        this.error = true;
        this.message = error;
        this.loading = false;
        console.error(error);
      },

      () => {
        this.loading = false;
      }
    );
  }

  export() {
    const filename: string = this.form.controls.file.value[0].name;
    const sheets = [
      {
        title: 'Invalid Records',
        rows: [this.headers]
          .concat(this.records
            .map(record => this.headers
              .map(header => record[header]))
          )
      },
    ];

    this.exportService.getExcelExport(sheets, filename.replace(/.csv$/, '_Errors'))
      .subscribe(response => window.document.location.href =
        `${window.location.protocol}//${window.location.hostname}/${response}`);
  }

  reset() {
    this.form.reset();
    this.error = false;
    this.message = '';
    this.records = [];
  }
}
