import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'ngcordova';
  p = 'not ready';
  start() {
    try {
      const w = window as any;
      w.cordova.plugins.Replay.startRecording(true,
        () => {
          this.p = ' start';
        }, () => {
          this.p = ' error';
        }
      );
    } catch(e: any) {
      this.p = e;
    }
  }
}
