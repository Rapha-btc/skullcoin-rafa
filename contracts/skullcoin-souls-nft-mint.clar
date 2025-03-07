;; Storage
(define-map presale-count principal uint) ;; this is a map of users and their pre-sale balance

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-SALE-NOT-ACTIVE (err u102))
(define-constant ERR-NO-MINTPASS-REMAINING (err u103))
(define-constant ERR-FATAL (err u104))

;; Variables
(define-data-var mintpass-sale-active bool false)
(define-data-var sale-active bool false)

;; Get presale balance
(define-read-only (get-presale-balance (account principal))
  (default-to u0
    (map-get? presale-count account)))

;; Check mintpass sales active
(define-read-only (mintpass-enabled)
  (ok (var-get mintpass-sale-active)))

;; Check public sales active
(define-read-only (public-enabled)
  (ok (var-get sale-active)))

;; Set mintpass sale flag (only contract owner)
(define-public (flip-mintpass-sale) 
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER)  ERR-NOT-AUTHORIZED)
    (var-set sale-active false) ;; set sale-active to false
    (var-set mintpass-sale-active (not (var-get mintpass-sale-active))) ;; change mintpass-sale-active
    (ok (var-get mintpass-sale-active)))) ;; spit out the result

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set mintpass-sale-active false)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Claim NFT
(define-public (claim)
  (if (var-get mintpass-sale-active) ;; if mintpass is true just go to mintpass-mint, else go to public-mint
    (mintpass-mint tx-sender) 
    (public-mint tx-sender)))

;; Claim 2 NFT
(define-public (claim-two)
  (begin
    (try! (claim))
    (try! (claim))
    (ok true)))

;; Claim 5 NFT
(define-public (claim-five)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (ok true)))

;; Claim 10 NFT
(define-public (claim-ten)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (ok true)))

;; Internal - Mint NFT using Mintpass
(define-private (mintpass-mint (new-owner principal))
  (let ((presale-balance (get-presale-balance new-owner)))
    (asserts! (> presale-balance u0) ERR-NO-MINTPASS-REMAINING) ;;pre-sale is a mint-pass okay
    (map-set presale-count
              new-owner
              (- presale-balance u1));; decrement the presale balance by 1
  (try! (contract-call? .skullcoin-souls-nft mint new-owner)) ;; mint the NFT
  (ok true)))

;; Internal - Mint NFT via public sale
(define-private (public-mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .skullcoin-souls-nft mint new-owner)) ;; mint 1 nft
    (ok true)))

;; Register this contract as allowed to mint
(as-contract (contract-call? .skullcoin-souls-nft set-mint-address)) ;; so this is the NFT contract


;; add new white listed address:
(define-public (add-white-list-address (friend principal)) ;; hello bogachev and Xenitron, thanks for sharing your code with me if you have a github?
;; all good, but you could have added this function, and why initiating # of NFTs to 2000, 500 was good too since the owner can extend the # of NFTS?
    (begin 
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (map-set presale-count friend u5)
        (ok true)
    )
)

;; Mintpasses
(map-set presale-count 'SPM06DTBFP2E6056NGR0Q3TEE5SW9ZYRA98XZ23S u5)
(map-set presale-count 'SP1VWZ87JH5QVYB1FZ9274Q597XR1ZAQ99KGCTEFS u5)
(map-set presale-count 'SP3AQSW210PFW6K3FB1JW62ZHTH11FSVR0SH5AZ6P u5)
(map-set presale-count 'SP6HYDNWHSSTZFS0HAR4FDRPXK3EK603S0BYJHFJ u5)
(map-set presale-count 'SPHK8A7P61C6ASWKYDX1PCDX9YA54DKVJN49EXGJ u5)
(map-set presale-count 'SP2SFZX1WJSKT1GA2STDT6E5NWDX44GW4BB8DW4DJ u5)
(map-set presale-count 'SP1S0B05BFW099N2C30W7T788QE4645M72EP6AV3X u5)
(map-set presale-count 'SP9R1DTP15B10S5WFPZVM8W2FDS6VXP27VA96CEZ u5)
(map-set presale-count 'SP2SSHDSGHHEQN1A7Z0RP0YJ6QECE8TGQTYN594PM u5)
(map-set presale-count 'SP3KXV3J6MRHAH4H89MDS390X1KS0GQN4DWQ5RFVB u5)
(map-set presale-count 'SP31ER8WTA6RM08Z0GNTY786T4PW6SYKFTNMTPRSV u5)
(map-set presale-count 'SP1FW0F2ZYZHXT1BVV8HX8ZXG3MRM0ZVH73QE9VSV u5)
(map-set presale-count 'SPV48Q8E5WP4TCQ63E9TV6KF9R4HP01Z8WS3FBTG u5)
(map-set presale-count 'SPZBHT1A5XDGHFZNP1V8HAHKQZFSJ7RKW4RBWAP7 u5)
(map-set presale-count 'SP77HNCX8KTBFTVKY6B40YAVS79GNA8BKQ84RV02 u5)
(map-set presale-count 'SP3VJCMXAGTVF4BJ81JGTYVEBCXWZARFN60D8VSKG u5)
(map-set presale-count 'SP2FZ154ESZ8NB34RZ3RS147GD6DSEYNE8DQD0XDM u5)
(map-set presale-count 'SP1GYWMYK320ASBBAERSC40TA3PA99ZHV3GF256T8 u5)
(map-set presale-count 'SP3YPMD71E1Q0WRW0949AT5MQ4M72GMP915CX1XTW u5)
(map-set presale-count 'SP2GHCPM134Y28EZKNKEMF7SBK0BQ1QW1QASYWS6Z u5)
(map-set presale-count 'SP2RWS7D7RW6DDZCTXJC0VTK86CKD0TF445116V8A u5)
(map-set presale-count 'SP3XVCXK5BTWY2MW93KW0KVZDWVVRR52PA6SDZT17 u5)
(map-set presale-count 'SP1K8RG4PV202FHT8J9023G1WJRPFTSZXN9TPNEJX u5)
(map-set presale-count 'SP3Z7511VWR5WG9J3MAKER3NRZYKWT83K2XTP36EV u5)
(map-set presale-count 'SP3NPM49B0MNKWYH05DP567H5NJ1QN91PEF4E2Z2D u5)
(map-set presale-count 'SP3P8PMKMYJQ9V16A6EZW2XHH1P29JN58R31VQ4VJ u5)
(map-set presale-count 'SP3PXDT0EKRBK8TPS6PNMQ4NY1QNWQ97AYV3KAXS6 u5)
(map-set presale-count 'SP2QPKZPPEBZ7ZB7E558TTW15X75S9VDHC09M9SJF u5)
(map-set presale-count 'SP3TZ3BCB16A0W0PPFYMGTTWTT3DVWTQEP8DFRAG1 u5)
(map-set presale-count 'SP9XD6041FFN5BW6ZR9J3FSESR4S442JPYZJVXBW u5)
(map-set presale-count 'SP2XJCFE0MZB33AAP91ZY8TXJ03HMXCJPJD71AJCM u5)
(map-set presale-count 'SP27P4FECZXC2TXPS24C1CCTNKB0K1JEK3SZK7CB u5)
(map-set presale-count 'SP3SF0PSD7KYVJQPKKRBYJFF7NENGFHZSBVHM3B27 u5)
(map-set presale-count 'SP2WVXXAMRWRYZ530616S3BKRGHMWCBEE9VSRJ6F6 u5)
(map-set presale-count 'SP3Q908CXM9E5CZB5P81BWXVNP8GRBFK793DW2685 u5)
(map-set presale-count 'SPEXAF3YRNCR01Z4DFZ567Z0FB4RKPHM88DMKJSQ u5)
(map-set presale-count 'SPAMKYYBRH59SNG3Q8X9KMWT0VSKXR1KMDQZQCTG u5)
(map-set presale-count 'SP2ZD78CEHCFPJ71SB8R0EK0ZMVAGB3NTHK947F06 u5)
(map-set presale-count 'SP38REZNW2QD8CSSQ3PZKWJZ84TTBTXDJDD20GKW4 u5)
(map-set presale-count 'SP2MC6PBPNPSEHA6G87DDMN6WX3HGMTANXZBYKCNF u5)
(map-set presale-count 'SP3YCQ2GBGYPQTBVQRP1ZCYW8CFZT48J6SYB7VZWE u5)
(map-set presale-count 'SPSV4TXVP768KRDHRHZBDHENG29M920A9G30R4BX u5)
(map-set presale-count 'SP1DPNP3RRD6JG1557SP6JMX68W5BV6R2Z74BQEXV u5)
(map-set presale-count 'SP3T156FGQ9J6H9A6AZY2BA6SJJCCHPZB0Z97STDF u5)
(map-set presale-count 'SP1XZ7KEMJT5V8ATRYZB0XWJ20KMGM37JXJZG9D6S u5)
(map-set presale-count 'SPAHTV25EDZPSFPSH3DGKN0ANRSDMEHYFVA1CS3N u5)
(map-set presale-count 'SPF4FR0X9Q4PAF6KENDD3NVAGQTM8A830A4F96YG u5)
(map-set presale-count 'SP3JCN7W79KNRJBBPBRPKJZ7TRCVAK1NGV2FX4ZH u5)
(map-set presale-count 'SP17YP1HGWK7DP5Q69GRG14W34E078S4D78YM1FA5 u5)
(map-set presale-count 'SPVS8CQ247EVN8VXE8SC087DTFCXR52YF4HXATZQ u5)
(map-set presale-count 'SPQ2HN9TYF8ZYY9D3G45NGYA9GHA6QZHQ8AXF5QM u5)
(map-set presale-count 'SP3E0ZRGHZM3R5VAFR41A5HD147T2T1TDTH5ZSKKF u5)
(map-set presale-count 'SP2CZMH9A6FH5QPAJAR8ZG091Z15JKAGY1X0F3EJ0 u5)
(map-set presale-count 'SP2HK7J6617VBSKXQGZWMXP2R64MMDX3S54M0S1Q6 u5)
(map-set presale-count 'SP14W78Q821B3HQ3ED30624Z1F13X4JMFZY3N5SK4 u5)
(map-set presale-count 'SP36KY6SG05FK21AZGTNNY7HD5CPH5MQT8Q85HPD8 u5)
(map-set presale-count 'SP162D87CY84QVVCMJKNKGHC7GGXFGA0TAR9D0XJW u5)
(map-set presale-count 'SP3R4NKXMGW6YXA44X2ESZPKJNV25X4ZN7DPW0RXR u5)
(map-set presale-count 'SPEXRA92V0H67ETCVGCX89D3Q4YRCV40T3DB001S u5)
(map-set presale-count 'SP3MB74HT9SDNGENKFDA3AKZEXEMBZWB1FTFSHWBJ u5)
(map-set presale-count 'SP3HD6JF8N5214S5Q7GHXBQGKY6XJNTRH0DS6P6KY u5)
(map-set presale-count 'SP2AYJHP9H3JM3T26ZBW0SKBCXJ9S4JW03VQBP7K1 u5)
(map-set presale-count 'SP20P02KXAW338AS0ED5HV0M37SNQRFAMPB0F1R51 u5)
(map-set presale-count 'SP77NT5VGM8XNMCTGK39Z1F6JRAX7GK7MWMS22TQ u5)
(map-set presale-count 'SP17873FB345DWNJ6Q9K7HJW56TVJ1D1QKHFFN7J2 u5)
(map-set presale-count 'SP22VVY6NQ4PCWC0FDKWP1TKN5J8SEWCS64TF3Y43 u5)
(map-set presale-count 'SP3EYT7KF5ERWQFTWW3SWHS8QRYBNSMRZ7JW73YXR u5)
(map-set presale-count 'SP24GRMRYV61X68KZWP2EVEH5X632GSF6WV9MSR1E u5)
(map-set presale-count 'SP3RBBZRRNA859PV207VJVNJBWZ9KRNMT9AN37M6E u5)
(map-set presale-count 'SP233DQ184TJ6QEVS6C40D364D74P82SG289MHHPK u5)
(map-set presale-count 'SP23NXVJWQARSPF1K3TD73MHVJE4EFV9V58GXHT73 u5)
(map-set presale-count 'SP25HZXKHGGZ2ASKXPF7R7QMG3QPYMQ6ZTGBSCVPS u5)
(map-set presale-count 'SP12PTJXN0Z0BHFKDRHS6SH7VTPBYDNMK2NBHAP4G u5)
(map-set presale-count 'SP1W205AJ74K0TP5CKPFY2ZWNM7PYHJW24WH16VQ6 u5)
(map-set presale-count 'SP22BKK9W9DMB785DN32N5KZGXJW8FCHKN647PTE6 u5)
(map-set presale-count 'SP1MTWXSYKN8PWCXC6MPJ3EVEK3FPPTW60VQAHK15 u5)
(map-set presale-count 'SP3PS33CQ9EF57T7TPCPBBR8MYR71P0SXABAZ73Q6 u5)
(map-set presale-count 'SP3ASY62X4S6897A76HA56HNG8XWSFBRJBARJB6FP u5)
(map-set presale-count 'SP1DSV96MNRXHMHG1P1ZVZS3HWCSTVVN7KRNKMF3C u5)
(map-set presale-count 'SP2N4H3KKNCTSY4MBY3E7N66QBQYP442J6Y5BNN7T u5)
(map-set presale-count 'SP1K9DH8FDC37GKNJXEHYSBCYHS490Y8Y34SDRZV4 u5)
(map-set presale-count 'SP1JV294RB4H9MDQKEBXNB75P5E8WZAK6BVHX08V4 u5)
(map-set presale-count 'SP29XJ067FRSH724V8P0VYYYAYAC4RWHDSK99E2TQ u5)
(map-set presale-count 'SP2YNR0V517X5W05SD0R54X8BKND1P9FW6GWDA4CN u5)
(map-set presale-count 'SP25EQTW2ZDA8RPR23BPJEM7E1EHKVR35H7BN9S1E u5)
(map-set presale-count 'SP3RK830M5SFM5M12NTDXFFYE9K8Y126HCQK42583 u5)
(map-set presale-count 'SP1KMTKCJSMFMDDV9AJQS6W0JBF4D7W70KYK954AV u5)
(map-set presale-count 'SP1D0X841JJXGATS8E9ADHFPE0N224Q55KCXKH2DT u5)
(map-set presale-count 'SPNAHTXH4C35G52A2JKK04HZP2DS8K9NNGAZ0MA3 u5)
(map-set presale-count 'SP1SM7VWTY94ZDA4MJ4YZS7FDSHKK24R1A5P1WR8A u5)
(map-set presale-count 'SPC4HZ8H8GQXQ6QF22ZT9BR1ER924NGN6PGH5RTB u5)
(map-set presale-count 'SP8M7A238QPM2D97S5HG97W2JB4AX5H49PHCG4X1 u5)
(map-set presale-count 'SP1P52D68Y5SK4D7TGFMV9RNDDF1EC3J3PJB310WJ u5)
(map-set presale-count 'SP3JRSKVESN9SSDQN4BFM037NA92H1VNJ9VY4XE7A u5)
(map-set presale-count 'SP3Y7Q70G793J64R5N7ZG5A6K860S15RVY7G0104 u5)
(map-set presale-count 'SP2RS70QTH74HCGRZTXYN6GQ950VY9CQPK8DM6EDZ u5)
(map-set presale-count 'SP1MDFWEQ587671675JAJ343P6RNMN9B1AM12SFCT u5)
(map-set presale-count 'SP26W0T2T2V1XPCC7SFE3YQRY9TGWT5S9P0KXG4XC u5)
(map-set presale-count 'SP1XG7MZMGK8H3FYYV8GE7FTANHMQX1BF01VRFDR6 u5)
(map-set presale-count 'SPJZWNSFDGG7YY9E56GCAA295BXP4XRK9CARAZS4 u5)
(map-set presale-count 'SP1DMNKCRESSJFD799HYWA9ZY4PX7Z6P6KMKVXG6Z u5)
(map-set presale-count 'SP2VMPP2DNTC1QWDTCHR5EAA7YTH8ETBCG61ZEJQM u5)
(map-set presale-count 'SP3AAJ9WQA73AFWT0N5ZEYZRY42WN11KPQG6Z2F5H u5)
(map-set presale-count 'SP30KV5KE2C5203WY8FWX9K36B79C013XN4QNQYSM u5)
(map-set presale-count 'SP15SDBWYX5T8R71DKPGG4NMJ45832FQZ9A4MZ7QJ u5)
(map-set presale-count 'SP1QN3ABM5KC7HP76T6A9P8DEMFJYPWTQECG7QVW6 u5)
(map-set presale-count 'SP2QFAB7MMHT86EN3M6DS8EQBTRPA9ZSGAXVNFAS0 u5)
(map-set presale-count 'SP1PZ0W0HWKGBVK42DZ615X7QGHYD10XCCP9YXA53 u5)
(map-set presale-count 'SP2KHKG5QJAMH9J7MD1S1DGZBRQF5T2GYQNCJ40FN u5)
(map-set presale-count 'SP9M54TTRH225M9HF6ZAXWPF77M4B0VTPC3MZYGE u5)
(map-set presale-count 'SP2ZY0WPGFXGCP5X7BSWYKBNHXETFPYVJXRPWFYEA u5)
(map-set presale-count 'SP1KS0MEQMAM3WGT908W5E7MWTE0RC6PDYQESKMNZ u5)
(map-set presale-count 'SP3GAYJ5TP9QTWH8NGV3K98ES9SD8SBK1WHFHSMTD u5)
(map-set presale-count 'SP23RS2V3BAWHNQ3RHVZHK10F51RA99C1FHQKY9QH u5)
(map-set presale-count 'SP4QA0NHP03T3T9GJKR5KEA7VQ2KNSXRK5JC74NG u5)
(map-set presale-count 'SPN4Y5QPGQA8882ZXW90ADC2DHYXMSTN8VAR8C3X u5)
(map-set presale-count 'SP197GMEG6WGBRDTCTGGWMRA1G77E65TRXWYKGCT7 u5)
(map-set presale-count 'SP3Y808KQW24TXXVBQ4S71Z22KC93QJCTAJS35GH0 u5)
(map-set presale-count 'SPKFFDMD9MCWWKY5GXADY8JEMNMS4NTXWJZEXD4J u5)
(map-set presale-count 'SP2YCTDRDMZ7ZJCY1B3AG2354VFCKWVPZA2ASMEJ6 u5)
(map-set presale-count 'SPP3HM2E4JXGT26G1QRWQ2YTR5WT040S5NKXZYFC u5)
(map-set presale-count 'SPDFFG562C4A3Y35RHATSMX7YGDKM1XTZBB3BZ2E u5)
(map-set presale-count 'SP1T07GK9H4M0WP4N1DSSA7NJ7GNTQZ0GBZM0GAR2 u5)
(map-set presale-count 'SP398XE371G08T84A99TCBD8XKWY3S7VVX6JKJWKY u5)
(map-set presale-count 'SP329G766AV8Z01X9EEAHPDQ4WDJXT2A0XB383MGP u5)
(map-set presale-count 'SP1KBVBP3AZP7YA968Y3G14A17P9XXFPBPEVF5EG9 u5)
(map-set presale-count 'SP25KJH4N4YNKTVXSWSHDPVCWDFAN2BA4H2VQVN0G u5)
(map-set presale-count 'SP36TQY03S4BSCZ734DPK561YZ8J4G0PH5V3N4DDA u5)
(map-set presale-count 'SP31WTJ415SNJM9H6202S3WK9AFQXQZMT48PESBQE u5)
(map-set presale-count 'SP3P8M5J25457Q73MKS8EGD5Z19Z57RKYSPNEAK85 u5)
(map-set presale-count 'SP364J7EDJXRE1FPDZDABP9M58HPY4G88BFCP2HD0 u5)
(map-set presale-count 'SPYF9PC72BSWS0DGA33FR24GCG81MG1Z96463H68 u5)
(map-set presale-count 'SPV00QHST52GD7D0SEWV3R5N04RD4Q1PMA3TE2MP u5)
(map-set presale-count 'SPZ5DJGRVZHXEEEYYGWEX84KQB8P69GC715ZRNW1 u5)
(map-set presale-count 'SP3R6M25MECQJCRW28KDBCR9N6HJDB9KT1QXZHN6R u5)
(map-set presale-count 'SP28RZ1QXMXJXVKRRCR3D7GR5D48XY0NNA9MZWHJB u5)
(map-set presale-count 'SP1CE3NQXDKCJ2KEFFGCVFA5C196S9F0RRX93HY87 u5)
(map-set presale-count 'SP1XPG9QFX5M95G36SGN9R8YJ4KJ0JB7ZXNH892N6 u5)
(map-set presale-count 'SP1B7FFVFHHBCB466DVJR02BQ7PS9TNW02YA29DR3 u5)