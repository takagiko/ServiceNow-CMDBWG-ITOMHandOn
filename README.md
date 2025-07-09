# ServiceNow CMDB分科会 ITOMハンズオン 環境構築用参考資料

ディスカバリ／サービスマッピングの対象サーバ・システムについて、簡単な掲示板システムを Apache httpd → Tomcat → PostgreSQL のシステム構成で構築しました。
構築するための情報を以下に記述します。

* 共通情報
  * 東京リージョン（ap-northeast-1）
  * 全てEC2の t3.large (2cores 8GB) Windows Server 2025 で作成
  * VPC 172.31.0.0/20
  * Discovery対象マシンには、以下のadmin権限ユーザを作成済み　Administrator / CmdbCsdm0001_

* WG-CMDB-001
  * 52.197.190.90 (Public IP)
  * 172.31.8.150 (Private IP)
  * Apache 2.4 をインストール。80 番ポートをリッスン。
    * https://www.apachelounge.com/download/ から Win64 用のバイナリをダウンロードしてインストール。
    * インストール先は C:\Apache24
    * httpd.conf は https://github.com/takagiko/ServiceNow-CMDBWG-ITOMHandOn/blob/main/WG-CMDB-001/httpd.conf の内容に書き換え
    * 上記の設定とすることで、http://52.197.190.90 でインターネットからアクセス可

* WG-CMDB-002
  * 172.31.8.11 (Private IP)
  * Tomcat 11 をインストール
    * https://tomcat.apache.org/download-11.cgi から Windows Service Installer のバイナリをダウンロードしてインストール
    * インストール先はデフォルトのまま
    * %tomcat_root%\conf\server.xml は https://github.com/takagiko/ServiceNow-CMDBWG-ITOMHandOn/blob/main/WG-CMDB-002/server.xml の内容に書き換え
    * %tomcat_root%\webapps\ROOT\index.jsp は https://github.com/takagiko/ServiceNow-CMDBWG-ITOMHandOn/blob/main/WG-CMDB-002/index.jsp の内容に書き換え
    * %tomcat_root%\lib 下に、以下を配置
      * commons-dbcp2-2.13.0.jar (https://commons.apache.org/proper/commons-dbcp/download_dbcp.cgi からダウンロード)
      * commons-pool2-2.12.1.jar (https://commons.apache.org/proper/commons-pool/download_pool.cgi からダウンロード)
      * commons-logging-1.3.4.jar (https://commons.apache.org/proper/commons-logging/download_logging.cgi からダウンロード))
      * postgresql-42.7.5.jar (https://jdbc.postgresql.org/download/ からダウンロード)

* WG-CMDB-003
  * 172.31.15.184 (Private IP)
  * PostgreSQL 17 をインストール
    * https://www.enterprisedb.com/downloads/postgres-postgresql-downloads から Windows x86-64 のバイナリをダウンロードしてインストール
    * インストール先はデフォルトのまま
    * インストール中にスーパーユーザのパスワードを設定する箇所があるので、CmdbWG2025 に設定。（https://github.com/takagiko/ServiceNow-CMDBWG-ITOMHandOn/blob/main/WG-CMDB-002/index.jsp の設定に合わせる）
