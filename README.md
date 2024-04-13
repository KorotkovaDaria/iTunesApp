# iTunesApp

iTunesApp - это приложение для iOS, предназначенное для поиска медиа-контента. Пользователи могут искать различные виды контента, такие как фильмы, подкасты и музыкальные альбомы, используя удобный интерфейс поиска. Приложение также сохраняет историю поиска и предоставляет подсказки на основе предыдущих запросов. После выбора элемента из результатов поиска, пользователи могут просматривать подробную информацию о контенте.

# Требования к реализации

Приложение имеет два экрана:

Экрана поиска медиа-контента

Экрана с детальной информацией, который отображается после нажатия на элемент из результатов поиска
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/MediaSearchScreen.png" width="200">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/ScreenWithDetailedInformation.png" width="200">
</div>

**Экран поиска**

Отображает строку ввода поискового запроса
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/MediaSearchScreen.png" width="200">
</div>

Сохраняет историю поиска. В момент начала ввода отображаются элементы-подсказки с ранее введенными значениями. Если нажать на подсказку, произойдет автозаполнение поисковой строки.
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/prompt.png" width="200">
</div>

В результатах поиска поддерживаются для отображения как минимум двух типов медиаконтента(подкасты, фильмы, альбомы). В каждом элементе поисковой выдачи отображена его принадлежность к типу, превью-изображение и название. Помимо этого элементы отображают краткую информацию, относящуюся к соответствующему типу контента.
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/сontent.png" width="200">
</div>

С экрана поиска открываться экран детальной информации по нажатию на элемент поисковой выдачи.

**Экран с детальной информацией**

Отображает детальную информацию о медиа-контенте:

Изображение для контента

Название материала

Имя автора материала

Тип контента 

Гиперссылка для перехода на страницу медиаконтента вне приложения

Описание

Блок должен содержать гиперссылку для перехода на страницу автора вне приложения 

Возможность отображать разный набор параметров в зависимости от типа контента

Лучшие альбомы(только для типа "альбомы"), сделанных автором с возможностью перехода внутри приложение в браузер Safari, где можно посмотреть подробную информацио об этом альбоме.

<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/detailAlbum1.png" width="180">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/detailAlbum2.png" width="180">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/detailMovie1.png" width="180">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/detailMovie2.png" width="180">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/detailPodcast.png" width="180">
</div>

**Нефункциональные требования**
Каждый экран должен поддерживать отображение трёх состояний:

Отображение контента
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/сontent.png" width="200">
</div>
Отображение ошибки
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/errorDisplay1.png" width="200">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/errorDisplay2.png" width="200">
</div>
Состояние загрузки
<div align="left">
  <img src="https://github.com/KorotkovaDaria/iTunesApp/blob/main/additional%20information%20for%20README/downloadStatus.PNG" width="200">
</div>
