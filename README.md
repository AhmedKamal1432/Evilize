<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/AhmedKamal1432/Evilize">
    <img src="https://github.com/AhmedKamal1432/Evilize/blob/main/Helper/images/Evilize-logos_transparent.png?raw=true" alt="Logo" width="30%" height="auto">
  </a>
  <p align="center">
    Hunting Evil by parsing Windows Event Logs files
    <br />
    <a href="https://github.com/AhmedKamal1432/Evilize/wiki"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/AhmedKamal1432/Evilize/issues">Report Bug</a>
    ·
    <a href="https://github.com/AhmedKamal1432/Evilize/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contributers">Contributers</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<img src="https://github.com/AhmedKamal1432/Evilize/blob/main/Helper/images/Evilize.gif?raw=true" alt="Tool GIF" width="100%" height="auto">

An incident response tool parses Windows Event Logs to export infection-related logs across many log files. Mainly following [Hunt Evil Sans Poster](https://share.ialab.dsu.edu/CRRC/Incident%20Response/Supplementary%20Material/SANS_Poster_2018_Hunt_Evil_FINAL.pdf) to choose related events.

what's new:
* One command to analyze all different infection-related Event logs files.
* Having a map of analysis based on different categories based on Sans Poster. 
* Tables of statistics of the number of indicators in every infections vector.
* Export useful events with important attributes in CSV format for extra manual analysis.
* analyise EVT and EVTX files

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [LogParser](https://www.microsoft.com/en-eg/download/details.aspx?id=24659)
    * This is the default option as it is a time-efficient and stable option.
* [WinEvent](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-7.1)
    * This is a flexible and programmable option as you can add your own code for extra analysis.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started



### Installation

* Download and Install [Logparser](https://www.microsoft.com/en-us/download/details.aspx?id=24659).
*  Add Log parser path to your machine environment variables [[Guide](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/)]
* Clone the repo
   ```sh
   git clone https://github.com/AhmedKamal1432/Evilize.git
   ```



<!-- USAGE EXAMPLES -->
## Usage

* Change Directory to the Repo Folder
* Run the .\Evilize.ps1 file with the directory of Events logs files (Don't run it on the logs in "C:\Windows\System32\winevt\Logs" )
```PS
.\Evilize.ps1 C:\Users\username\Downloads\Events\EventLogs\
```
* As Security.evtx file may be to large, so it wll not parse it by default. if you want to parse it pass the `-security` parameter
```PS
.\Evilize.ps1 C:\Users\username\Downloads\Events\EventLogs\ -security
```
*  `winevent` parameter to run WinEvent parsers
```PS
.\Evilize.ps1 C:\Users\username\Downloads\Events\EventLogs\ -winevent -security
```
* _For more examples, please refer to the [Wiki](https://github.com/AhmedKamal1432/Evilize/wiki)_

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [v1.1.0] Implement Source events parsers
- [v1.2.0] Multithreaded parsers
- [v1.2.0] Date/Time filters
 
See the [open issues](https://github.com/AhmedKamal1432/Evilize/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



## Contributers
* [Sayed Omar](https://github.com/sayedomarr)
* [Magy Gamal](https://github.com/MagyGamal)
* [Ahmed Kamal](https://github.com/AhmedKamal1432)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Sans](https://www.sans.org/)
* [Best-README-Template](https://github.com/othneildrew/Best-README-Template)
* [Parserator](https://github.com/psanchezcordero/Parserator/blob/main/Parserator.ps1)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AhmedKamal1432/Evilize.svg?style=for-the-badge
[contributors-url]: https://github.com/AhmedKamal1432/Evilize/contributors
[forks-shield]: https://img.shields.io/github/forks/AhmedKamal1432/Evilize.svg?style=for-the-badge
[forks-url]: https://github.com/AhmedKamal1432/Evilize/network/members
[stars-shield]: https://img.shields.io/github/stars/AhmedKamal1432/Evilize.svg?style=for-the-badge
[stars-url]: https://github.com/AhmedKamal1432/Evilize/stargazers
[issues-shield]: https://img.shields.io/github/issues/AhmedKamal1432/Evilize.svg?style=for-the-badge
[issues-url]: https://github.com/AhmedKamal1432/Evilize/issues
[license-shield]: https://img.shields.io/github/license/AhmedKamal1432/Evilize.svg?style=for-the-badge
[license-url]: https://github.com/AhmedKamal1432/Evilize/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/ahmed-kamal1432
[product-screenshot]: images/screenshot.png