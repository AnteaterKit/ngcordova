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
    const w = window as any;
    console.log('plugins.Replay.startBroadcast ', w.cordova.plugins);
    try {
      
      w.cordova.plugins.Replay.startBroadcast(
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
