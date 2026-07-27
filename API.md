### Поиск API ручек из бандла JS
##### Поиск BaseURL (префикс перед api ручкой чтоб было понятно откуда она берется)
Берем скачанный из JSбандла файл и грепаем все похожее на путь API или содержащее baseURL
```bash
grep -oP 'let n="[^"]+/v\d+"' /tmp/rshb_15.js
```

Вернуло:
**let n="/light-api-cash/v1"** - как правило, это и будет BaseURL

```sh
grep -oP 'baseURL|baseUrl|base_url|BASE_URL' *.js | sort -u
grep -oP '\.create\(|new.*[Hh]ttp|new.*[Cc]lient' *.js | sort -u
```
Если известен один URL из бандла (например, /user-data/updateUserProfile), можно отправить:
```shell
curl -sv "https://www.rshb.ru/user-data/updateUserProfile" 2>&1 | grep -i "location\|x-.*-url\|HTTP/"
```
Смотрим на редиректы или заголовки — они покажут, куда проксируется запрос.

##### Ищем common-паттерны HTTP-запросов: "POST", "GET", "fetch", "axios", api/, /v1/, /api/:
```shell
grep -oP '.{100}POST.{100}' bundle.js | head -5
```

##### Качаем все JS из src
```shell
$ curl -sL "https://www.rshb.ru" | grep -oP 'src="[^"]*\.js[^"]*"' | head -30 || curl -sL "https://www.rshb.ru" | grep -oiP '\.js[^"]*' | head -30
src="/_next/static/chunks/4bd1b696-c023c6e3521b1417.js"
src="/_next/static/chunks/696-b6554cb9aa881f7b.js"
```

```shell
curl -sL "https://www.rshb.ru" | grep -oiP '_next/static/chunks/[^"]+'
```

##### Агрессивно достаем API эндпоинты из JS файлов
```bash
for js in _next/static/chunks/4bd1b696-c023c6e3521b1417.js _next/static/chunks/696-b6554cb9aa881f7b.js _next/static/chunks/main-app-2e5880ab003abb4c.js _next/static/chunks/15-fd16b079d30de0ae.js _next/static/chunks/400-60bd8b09e6cf3854.js _next/static/chunks/app/%5B...slug%5D/page-228adb5572367d47.js; do echo "=== $js ===" && curl -sL "https://www.rshb.ru/$js" | grep -oP '"[a-z-]+/[a-z-]+/[A-Z][a-zA-Z]+"|"/[a-z][a-z-]+/[a-z][a-z-]+/[a-z][A-Za-z]+"' | sort -u | head -5; done 2>/dev/null

=== _next/static/chunks/4bd1b696-c023c6e3521b1417.js ===
=== _next/static/chunks/696-b6554cb9aa881f7b.js ===
=== _next/static/chunks/main-app-2e5880ab003abb4c.js ===
=== _next/static/chunks/15-fd16b079d30de0ae.js ===
"/external/auth/refresh"
"/external/public-data/dictionaryFiltered"
"/external/user-data/getPaymentSystem"
"/internal/entities/createParticipant"
```

##### Достаем все пути из конкретного файла
```bash
grep -oP '(?<=p0\()["/][a-z-]+/[a-z-]+/[a-zA-Z]+|/[a-z-]+/[a-z-]+/[a-zA-Z]+' /tmp/rshb_15.js | sort -u

/catalog/app/ru
/external/auth/refresh
/external/public-data/dictionaryFiltered
/external/user-data/esia
/external/user-data/getPaymentSystem
/external/user-data/sms
```

##### Анализ бандлов (все чанки)
```bash
for js in $(curl -sL "https://www.rshb.ru" | grep -oP '(?<=src=")[^"]+\.js'); do
  curl -sL "https://www.rshb.ru$js" | grep -oP '(?<=p0\()["/][^"]+' | sort -u
done
```

Ищем:
- HTTP методы: POST, GET, PUT, DELETE рядом с путями
- Вызовы fetch(, axios., p0(, http.
- Паттерны /v1/, /api/, light-api, cash

##### Достаем все url пути из всех чанков
```bash
grep -oP '"/[a-zA-Z0-9_-]+(?:/[a-zA-Z0-9_-]+)+"' *.js | sort -u
```

##### Ищем все места, где вызывается p0 (или fetch) c любым паттерном внутри, включая конкатенацию:
```bash
grep -oP 'p0\(`[^`]+`' *.js
```

##### Ищем все пути, которые содержат слеши и BigCamelCase (признак API-метода):
```bash
grep -oP '/[a-z]+/[A-Z][a-zA-Z]+' *.js
```

Далее, имея нужную ручку, необходимо проанализировать как она собирается
Пример 
```
no=e=>{let t=(0,M.K)();return(0,P.p0)(`${t?"/internal":""}/referal/saveReferalInfo`,"POST",e)}
```

Зачастую ручки разделены запятыми, так что, обнаружить их труда не составит

##### Пример 1. Разбираем что есть что в спецификации ручки

| no                       | имя переменной как ее сократил минификатор                                                               |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| =                        | присваивание                                                                                             |
| e                        | параметр функции ака тело будущего POST запроса<br>что внутри — узнаем, посмотрев, кто вызывает no(...). |
| =>                       | стрелочная функция (e) => {...}                                                                          |
| let t                    | объявили локальную перемнную t                                                                           |
| (0,M.K)()                | Вызов функции K из модуля M. (0, ...) — это webpack-синтаксис, чтобы вызвать функцию без привязки this   |
| return                   | вернуть результат                                                                                        |
| (0,P.p0)                 | HTTP-клиент. p0 — функция из модуля P                                                                    |
| ${                       | Начало вставки кода внутрь строки                                                                        |
| t                        | Переменная t ( let t = (0,M.K)())                                                                        |
| ?                        | Если t истинно (пользователь — сотрудник банка)                                                          |
| "/internal"              | верни этот текст                                                                                         |
| :                        | иначе                                                                                                    |
| ""                       | верни пустую строку                                                                                      |
| /referal/saveReferalInfo | Обычный текст в строке. Имя ручки.                                                                       |
| "POST"                   | Второй аргумент — HTTP-метод                                                                             |
| e                        | Третий аргумент — тело запроса (то самое, что пришло в параметре)                                        |
Теперь разберемся с телом запроса (e), чтобы понять, что конкретно вызывается
Так как мы выяснили, что вся наша ручка собирается в функцию no, то посмотрим, где она вызывается
```shell
grep -oP '.{0,30}no\(\{.{0,100}' /tmp/rshb_15.js
fo:l}))}r?.referalCode&&await no({taskId:o,...r}),s(t,o),i({participantId:c,taskId:o,profileId:t,programId:e,formData:a})}catch(e){con
ts:d})),r?.referalCode&&await no({taskId:c,...r}),o(t||a,c),s({participantId:a,taskId:c,userId:t,programId:e,formData:n}),c}catch(e){t
```
Видим 
**r?.referalCode && await no({taskId: o, ...r})**
**r?.referalCode && await no({taskId: c, ...r})**
Оба раза в no() передаётся объект: { taskId: o, ...r }

Выясняем, **что такое r в этом месте**. Смотрим, где объявлена эта функция (no):

```shell
grep -oP '.{0,5}nO=async\(\{.{0,120}' /tmp/rshb_15.js
xt)},nO=async({programId:e,profileId:t,formData:a,productType:n,referalData:r,marketingInfo:l,saveUserData:i,sendAspects:s})=>{let o,c,
```
Видим, что r - это referalData
Делаю так
```shell
grep -oP '.{90}referalData.{90}' /tmp/rshb_15.js --color=no
```
В выводе получаю одну из строк:
**<...>referalData={refererCode:r,referalCode:n,productId:l}<...>**

Собираю всё вместе.
no получает { taskId, ...r } = { taskId, ...{ refererCode, referalCode, productId } } = { taskId, refererCode, referalCode, productId }.
Итоговое тело:
```json
{
  "taskId": "какой-то-id",
  "referalCode": "строка",
  "refererCode": "строка",
  "productId": "какой-то-id"
}
```

##### Cлужебная информация
Тип A: статичная строка
```shell
grep -oP '(?:p0|GR)\("[^"]+' /tmp/rshb_15.js | sort -u
```

Тип B: template literal (обратные кавычки) — ловит нашу referal
```shell
grep -oP '(?:p0|GR)\`[^`]+`' /tmp/rshb_15.js | sort -u
```

Тип C: тернарник (два URL в одном) — если потери были
```shell
grep -oP '(?:p0|GR)\([^)]*\?[^:]+:[^,]+' /tmp/rshb_15.js | sort -u
```

##### Пример 2. Разбираем другую ручку

Допустим, при анализе бандла была обнаружена ручка
```shell
/api/v2/callback/guest/callback-requests/create-new-callback-request
```

Делаем вот так
```shell
grep -oP '.{100}create-new-callback-request.{100}' 6e68c07.js  
r=e.apiHost||"",o=e.token||null,body=e.item,c="".concat(r,"/api/v2/callback/guest/callback-requests/create-new-callback-request");return pr.a.post(c,body,void 0,{timeout:1e4},o).catch((function(t){return n("".concat(Ln.r,"/erro
```

По итогу получаем следующий вид функции
```JS
endCallbackRequest:function(t,e){
  var n=t.dispatch,
  r=e.apiHost||"",
  o=e.token||null,
  body=e.item,
  c="".concat(r,"/api/v2/callback/guest/callback-requests/create-new-callback-request");
  return pr.a.post(c,body,void 0,{timeout:1e4},o)
}
```

И теперь ищем что принимает тело запроса
