# 出題内容の確認記録

確認日：2026-11-02。45問の参照先本文を取得し、下記の設計判断と照合。実際の試験問題の転載は行っていません。AWS仕様の変更時は再確認してください。

HTTP成功のみを技術内容の確認とは扱いません。各問の条件と正解・誤答理由を見直し、特にAZ構成、キャッシュ、接続プール、暗号化の範囲を区別しました。

| 問題 | 確認した判断・条件 | 公式資料 |
| --- | --- | --- |
| saa-01 | EC2ロールの一時認証情報。長期キーと配布処理を不要にする。 | [参照](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html) |
| saa-02 | 非公開DBとアプリSGからDBポートへの明示的な許可。同一SGの付与だけでは許可しない。 | [参照](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html) |
| saa-03 | Block Public AccessでACLとポリシーの誤公開を防止。Object Ownershipだけでは公開ポリシーを防げない。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html) |
| saa-04 | カスタマーマネージドキーとAWSマネージドキーの管理権限を区別。HTTPSは転送時の保護。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html) |
| saa-05 | Multi-AZ DBインスタンスの同期スタンバイと自動切替。読み取りレプリカやMulti-AZ DBクラスターとは区別。 | [参照](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZSingleStandby.html) |
| saa-06 | 複数AZのASGで障害検知と台数回復。ALBと外部セッションの前提を明記。 | [参照](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-benefits.html) |
| saa-07 | SQSの永続キューで受付とワーカーを非同期化。直接HTTP配送だけと区別。 | [参照](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html) |
| saa-08 | SNSと用途別SQSによるファンアウト。キュー共有は用途別の全件配送にならない。 | [参照](https://docs.aws.amazon.com/sns/latest/dg/sns-sqs-as-subscriber.html) |
| saa-09 | リージョナルEFSと各AZのマウントターゲット。One Zoneと区別するためAZ障害要件を追加。 | [参照](https://docs.aws.amazon.com/efs/latest/ug/whatisefs.html) |
| saa-10 | CloudFrontのエッジキャッシュで低遅延配信とオリジン負荷削減。 | [参照](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) |
| saa-11 | RDS非同期リードレプリカへSELECTを分離。DBインスタンス型のスタンバイは読み取り不可。 | [参照](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html) |
| saa-12 | オンデマンドは事前容量計画を削減。急増時の制約やクォータがある旨を補足。 | [参照](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/on-demand-capacity-mode.html) |
| saa-13 | 再実行可能な中断許容バッチにはSpot。一定継続利用のコミットメントと区別。 | [参照](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html) |
| saa-14 | 通常3〜5時間の標準復元とDeep Archiveの通常12時間を区別。復元時間は保証値と表現しない。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects-retrieval-options.html) |
| saa-15 | 同一リージョン・VPC内IPv4という条件で無料のS3ゲートウェイエンドポイントを選ぶ。 | [参照](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-s3.html) |
| saa-16 | Secrets ManagerでDBとシークレットの値を連動してローテーション。単なる暗号化保存と区別。 | [参照](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html) |
| saa-17 | SCPの組織的な権限上限。メンバーアカウントのEC2作成に限定しグローバルサービスの例外と混同しない。 | [参照](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) |
| saa-18 | 第三者ロールのExternal ID条件でconfused deputyに対処。権限限定だけと区別。 | [参照](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_common-scenarios_third-party.html) |
| saa-19 | 通常のS3オリジンへのOACとポリシー。WebサイトエンドポイントはOAC非対応。 | [参照](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html) |
| saa-20 | 主系優先のDNSフェイルオーバー。加重やレイテンシーによる通常時配分と区別。 | [参照](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-failover.html) |
| saa-21 | DLQのredriveとmaxReceiveCount。タイムアウトや保持期間変更だけでは隔離できない。 | [参照](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html) |
| saa-22 | セッションの共有ストア化。スティッキーセッションだけではサーバー消失から保護できない。 | [参照](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_mitigate_interaction_failure_stateless.html) |
| saa-23 | Step Functionsで手順・再試行・分岐をオーケストレーション。 | [参照](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html) |
| saa-24 | キャッシュアサイドとTTL。RDS Proxyの接続プールやDBレプリカとの違いを明示。 | [参照](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html) |
| saa-25 | RDS Proxyの接続プール。予約済み同時実行数は抑制であってプールではない。 | [参照](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html) |
| saa-26 | Kinesisの保持されたストリームを独立したコンシューマーが読む。 | [参照](https://docs.aws.amazon.com/streams/latest/dev/introduction.html) |
| saa-27 | Athenaのパーティションと列指向形式。ストレージクラス変更はスキャン削減ではない。 | [参照](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning-data-optimization-techniques.html) |
| saa-28 | gp3で容量と性能を独立設定。実際の移行は必要性能と料金の見積もりが前提。 | [参照](https://docs.aws.amazon.com/ebs/latest/userguide/general-purpose.html) |
| saa-29 | Compute Savings Plansのリージョン・ファミリーをまたぐ柔軟性。 | [参照](https://docs.aws.amazon.com/savingsplans/latest/userguide/plan-types.html) |
| saa-30 | 128KB以上を自動階層化。任意の非同期アーカイブ階層を無効としミリ秒取得を維持。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering-overview.html) |
| saa-31 | WAFのSQL検査とIP単位レート制御。SGやShield Standardとの役割を区別。 | [参照](https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html) |
| saa-32 | 消費者向けユーザープールの登録・認証。IDプールの一時AWS認証情報と区別。 | [参照](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools.html) |
| saa-33 | SGはステートフル、NACLはステートレス。応答用ルールの必要性の違い。 | [参照](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) |
| saa-34 | Secrets ManagerのインターフェイスVPCエンドポイントで閉域接続。 | [参照](https://docs.aws.amazon.com/secretsmanager/latest/userguide/vpc-endpoint-overview.html) |
| saa-35 | MacieによるS3内の機密情報検出。GuardDutyの脅威検出、Configの設定監査と区別。 | [参照](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html) |
| saa-36 | Object Lock complianceの保持期間中はrootでもバージョン削除不可。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html) |
| saa-37 | ゾーナル構成維持を明記。リージョナルNATが利用できる現在の仕様に合わせ一意性を確保。 | [参照](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-basics.html) |
| saa-38 | 縮小した稼働環境を持つwarm standbyとpilot lightを区別。 | [参照](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html) |
| saa-39 | CRRの両バケットでのバージョニングと複製権限。新規オブジェクトに限定。 | [参照](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-requirements.html) |
| saa-40 | Aurora Global Databaseのリージョン間複製とローカル読み取り。スナップショットと区別。 | [参照](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html) |
| saa-41 | DAXの結果整合性キャッシュ。容量モードやグローバルテーブルと区別。 | [参照](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html) |
| saa-42 | FSx for Windows File ServerのSMBとAD統合。NFSやLustreと区別。 | [参照](https://docs.aws.amazon.com/fsx/latest/WindowsGuide/what-is.html) |
| saa-43 | Global AcceleratorのTCP/UDPと固定Anycast IP。CloudFrontにも静的Anycast IPがあるためIPだけを違いにしない。 | [参照](https://docs.aws.amazon.com/global-accelerator/latest/dg/what-is-global-accelerator.html) |
| saa-44 | DataSyncのNFS→S3の差分転送とスケジュール。毎日という条件で最小1時間間隔の制約を満たす。 | [参照](https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html) |
| saa-45 | Budgetsの予測通知。CloudWatch請求アラームの実績監視と区別。通知だけで支出を停止しない。 | [参照](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html) |

補足資料：

- [リージョナルNAT](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateways-regional.html)
- [CloudFrontのAnycast静的IP](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/request-static-ips.html)
- [Global AcceleratorのTCP/UDPリスナー](https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.html)
- [DataSyncのスケジュール](https://docs.aws.amazon.com/datasync/latest/userguide/task-scheduling.html)
- [AWS WAFのルール](https://docs.aws.amazon.com/waf/latest/developerguide/waf-rules.html)
