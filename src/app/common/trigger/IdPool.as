package common.trigger {
   
   public class IdPool
   {
      
//===================================================================
// event ids
//===================================================================
      
      public static const EventId_0:int = 0;
      public static const EventId_1:int = 1;
      public static const EventId_2:int = 2;
      public static const EventId_3:int = 3;
      
      public static const EventId_10:int = 10;
      
      public static const EventId_30:int = 30;
      public static const EventId_31:int = 31;
      public static const EventId_32:int = 32;
      public static const EventId_33:int = 33;
      
      public static const EventId_50:int = 50;
      
      public static const EventId_70:int = 70;
      public static const EventId_71:int = 71;
      public static const EventId_72:int = 72;
      
      public static const EventId_80:int = 80;
      
      public static const EventId_90:int = 90;
      public static const EventId_91:int = 91;
      
      public static const EventId_111:int = 111;
      public static const EventId_112:int = 112;
      
      //public static const EventId_130:int = 130;
      public static const EventId_131:int = 131;
      public static const EventId_132:int = 132;
      public static const EventId_133:int = 133;
      
      public static const EventId_150:int = 150;
      
      public static const EventId_200:int = 200;
      public static const EventId_201:int = 201;
      public static const EventId_202:int = 202;
      public static const EventId_203:int = 203;
      public static const EventId_204:int = 204;
      public static const EventId_205:int = 205;
      public static const EventId_206:int = 206; 
      public static const EventId_207:int = 207;
      
      public static const EventId_210:int = 210;
      public static const EventId_211:int = 211;
      public static const EventId_212:int = 212;
      public static const EventId_213:int = 213;
      
      public static const EventId_220:int = 220;
      public static const EventId_221:int = 221;
      public static const EventId_222:int = 222;
      
   // ================================
      
      public static const NumEventTypes:int = 300;
      
//===============================================================================================
//
//===============================================================================================

      
   // the ids less than 8196 will be reserved for official core apis
      
      public static const CoreApiId_0:int = 0; // 
      
      public static const CoreApiId_10:int = 10; // 
      public static const CoreApiId_11:int = 11; // 
      public static const CoreApiId_12:int = 12; // 
      public static const CoreApiId_13:int = 13; // 
      
      public static const CoreApiId_20:int = 20; //
      public static const CoreApiId_21:int = 21; //
      public static const CoreApiId_22:int = 22; //
      
      public static const CoreApiId_70:int = 70; //
      public static const CoreApiId_71:int = 71; //
      public static const CoreApiId_72:int = 72; //
      
      public static const CoreApiId_120:int = 120; // 
      public static const CoreApiId_121:int = 121; // to exchange with 122
      public static const CoreApiId_122:int = 122; //
      
      public static const CoreApiId_150:int = 150; // 
      public static const CoreApiId_151:int = 151; // 
      public static const CoreApiId_152:int = 152; // 
      public static const CoreApiId_153:int = 153; // 
      
      public static const CoreApiId_170:int = 170; // 
      public static const CoreApiId_171:int = 171; // 
      public static const CoreApiId_172:int = 172; // 
      public static const CoreApiId_173:int = 173; // 
      public static const CoreApiId_174:int = 174; // // to put after ID_Bool_Assign
      
      public static const CoreApiId_180:int = 180; // 
      public static const CoreApiId_181:int = 181; // 
      public static const CoreApiId_182:int = 182; // 
      public static const CoreApiId_183:int = 183; // 
      public static const CoreApiId_184:int = 184; // 
      public static const CoreApiId_185:int = 185; // 
      
      public static const CoreApiId_210:int = 210; // 
      public static const CoreApiId_211:int = 211; // 
      
      public static const CoreApiId_230:int = 230; // 
      public static const CoreApiId_231:int = 231; // 
      public static const CoreApiId_232:int = 232; // 
      public static const CoreApiId_233:int = 233; // 
      
      public static const CoreApiId_300:int = 300; // 
      public static const CoreApiId_301:int = 301; // 
      public static const CoreApiId_302:int = 302; //
      public static const CoreApiId_303:int = 303; //
      public static const CoreApiId_304:int = 304; //
      
      public static const CoreApiId_306:int = 306; // 
      public static const CoreApiId_307:int = 307; // 
      public static const CoreApiId_308:int = 308; // 
      public static const CoreApiId_309:int = 309; // 
      public static const CoreApiId_310:int = 310; // 
      public static const CoreApiId_311:int = 311; // 
      public static const CoreApiId_312:int = 312; // 
      public static const CoreApiId_313:int = 313; // 
      public static const CoreApiId_314:int = 314; // 
      
      public static const CoreApiId_315:int = 315; // 
      public static const CoreApiId_316:int = 316; // 
      public static const CoreApiId_317:int = 317; // 
      public static const CoreApiId_318:int = 318; // 
      public static const CoreApiId_319:int = 319; // 
      public static const CoreApiId_320:int = 320; // 
      public static const CoreApiId_321:int = 321; // 
      
      public static const CoreApiId_350:int = 350; // 
      public static const CoreApiId_351:int = 351; // 
      public static const CoreApiId_352:int = 352; // 
      public static const CoreApiId_353:int = 353; // 
      public static const CoreApiId_354:int = 354; // 
      public static const CoreApiId_355:int = 355; // 
      public static const CoreApiId_356:int = 356; // 
      
      public static const CoreApiId_380:int = 380; // 
      public static const CoreApiId_381:int = 381; // 
      public static const CoreApiId_382:int = 382; // 
      
      public static const CoreApiId_400:int = 400; // 
      public static const CoreApiId_401:int = 401; // 
      public static const CoreApiId_402:int = 402; // 
      public static const CoreApiId_403:int = 403; // 
      public static const CoreApiId_404:int = 404; //
      //public static const CoreApiId_405:int = 405; //
      
      public static const CoreApiId_500:int = 500; // 
      public static const CoreApiId_501:int = 501; // 
      
      public static const CoreApiId_510:int = 510; // 
      public static const CoreApiId_511:int = 511; // 
      public static const CoreApiId_512:int = 512; // 
      public static const CoreApiId_513:int = 513; // 
      public static const CoreApiId_514:int = 514; // 
      public static const CoreApiId_515:int = 515; // 
      public static const CoreApiId_516:int = 516; // 
      public static const CoreApiId_517:int = 517; // 
      public static const CoreApiId_518:int = 518; // 
      public static const CoreApiId_519:int = 519; // 
      
      public static const CoreApiId_530:int = 530; //
      public static const CoreApiId_531:int = 531; //
      
      public static const CoreApiId_600:int = 600; // design
      public static const CoreApiId_601:int = 601; // design
      public static const CoreApiId_602:int = 602; // design
      public static const CoreApiId_603:int = 603; // design
      
      public static const CoreApiId_609:int = 609; // design
      public static const CoreApiId_610:int = 610; // design
      public static const CoreApiId_612:int = 612; // design
      public static const CoreApiId_614:int = 614; // design
      
      public static const CoreApiId_700:int = 700; // world
      
      public static const CoreApiId_710:int = 710; // world
      public static const CoreApiId_711:int = 711; // world
      public static const CoreApiId_712:int = 712; // world
      
      public static const CoreApiId_720:int = 720; // world
      public static const CoreApiId_721:int = 721; // world
      public static const CoreApiId_722:int = 722; // world
      //public static const CoreApiId_723:int = 723; // world
      public static const CoreApiId_725:int = 725; // world
      
      public static const CoreApiId_750:int = 750; // world
      public static const CoreApiId_751:int = 751; // world
      public static const CoreApiId_752:int = 752; // world
      public static const CoreApiId_753:int = 753; // world
      public static const CoreApiId_754:int = 754; // world      
      public static const CoreApiId_755:int = 755; // world      
      
      public static const CoreApiId_770:int = 770; // world      
      
      public static const CoreApiId_850:int = 850; // CCat
      public static const CoreApiId_851:int = 851; // CCat
      public static const CoreApiId_852:int = 852; // CCat
      public static const CoreApiId_853:int = 853; // CCat, to ptu after ID_CCat_Assign
      
      public static const CoreApiId_900:int = 900; // entity.shape
      public static const CoreApiId_901:int = 901; // entity.shape
      public static const CoreApiId_902:int = 902; // entity.shape
      
      public static const CoreApiId_910:int = 910; // entity.shape
      public static const CoreApiId_911:int = 911; // entity.shape
      public static const CoreApiId_912:int = 912; // entity.shape
      public static const CoreApiId_913:int = 913; // entity.shape
      public static const CoreApiId_914:int = 914; // entity.shape
      public static const CoreApiId_915:int = 915; // entity.shape
      public static const CoreApiId_916:int = 916; // entity.shape
      
      public static const CoreApiId_980:int = 980; // entity 
      public static const CoreApiId_981:int = 981; // entity 
      public static const CoreApiId_982:int = 982; // entity 
      public static const CoreApiId_983:int = 983; // entity 
      public static const CoreApiId_984:int = 984; // entity 
      public static const CoreApiId_985:int = 985; // entity 
      
      public static const CoreApiId_1001:int = 1001; // entity 
      //public static const CoreApiId_1002:int = 1002; // entity 
      //public static const CoreApiId_1003:int = 1003; // entity 
      //public static const CoreApiId_1004:int = 1004; // entity 
      public static const CoreApiId_1005:int = 1005; // entity 
      //public static const CoreApiId_1006:int = 1006; // entity 
      public static const CoreApiId_1007:int = 1007; // entity 
      //public static const CoreApiId_1008:int = 1008; // entity 
      public static const CoreApiId_1010:int = 1010; // entity 
      public static const CoreApiId_1011:int = 1011; // entity 
      
      public static const CoreApiId_1049:int = 1049; // entity 
      public static const CoreApiId_1050:int = 1050; // entity 
      
      public static const CoreApiId_1060:int = 1060; // entity 
      
      public static const CoreApiId_1095:int = 1095; // entity.shape physics
      public static const CoreApiId_1096:int = 1096; // entity.shape physics
      public static const CoreApiId_1097:int = 1097; // entity.shape physics
      public static const CoreApiId_1098:int = 1098; // entity.shape
      public static const CoreApiId_1099:int = 1099; // entity.shape
      public static const CoreApiId_1100:int = 1100; // entity.shape
      public static const CoreApiId_1101:int = 1101; // entity.shape
      public static const CoreApiId_1102:int = 1102; // entity.shape physics
      public static const CoreApiId_1103:int = 1103; // entity.shape physics
      public static const CoreApiId_1104:int = 1104; // entity.shape physics
      public static const CoreApiId_1105:int = 1105; // entity.shape physics
      public static const CoreApiId_1106:int = 1106; // entity.shape physics
      public static const CoreApiId_1107:int = 1107; // entity.shape physics
      public static const CoreApiId_1108:int = 1108; // entity.shape physics
      public static const CoreApiId_1109:int = 1109; // entity.shape physics
      public static const CoreApiId_1110:int = 1110; // entity.shape
      public static const CoreApiId_1111:int = 1111; // entity.shape
      public static const CoreApiId_1112:int = 1112; // entity.shape
      public static const CoreApiId_1113:int = 1113; // entity.shape
      
      public static const CoreApiId_1130:int = 1130; // entity.shape physics
      public static const CoreApiId_1131:int = 1131; // entity.shape physics
      public static const CoreApiId_1132:int = 1132; // entity.shape physics
      public static const CoreApiId_1133:int = 1133; // entity.shape physics
      public static const CoreApiId_1134:int = 1134; // entity.shape physics
      public static const CoreApiId_1135:int = 1135; // entity.shape physics
      public static const CoreApiId_1136:int = 1136; // entity.shape physics
      public static const CoreApiId_1137:int = 1137; // entity.shape physics
      public static const CoreApiId_1138:int = 1138; // entity.shape physics
      public static const CoreApiId_1139:int = 1139; // entity.shape physics
      
      public static const CoreApiId_1150:int = 1150; // entity.shape physics
      //public static const CoreApiId_1151:int = 1151; // entity.shape physics
      public static const CoreApiId_1152:int = 1152; // entity.shape physics
      public static const CoreApiId_1153:int = 1153; // entity.shape physics
      //public static const CoreApiId_1154:int = 1154; // entity.shape physics
      public static const CoreApiId_1155:int = 1155; // entity.shape physics
      public static const CoreApiId_1156:int = 1156; // entity.shape physics
      public static const CoreApiId_1157:int = 1157; // entity.shape physics
      public static const CoreApiId_1158:int = 1158; // entity.shape physics
      //public static const CoreApiId_1159:int = 1159; // entity.shape physics
      //public static const CoreApiId_1160:int = 1160; // entity.shape physics
      public static const CoreApiId_1161:int = 1161; // entity.shape physics
      public static const CoreApiId_1162:int = 1162; // entity.shape physics
      
      public static const CoreApiId_1252:int = 1252;
      public static const CoreApiId_1253:int = 1253;
      
      public static const CoreApiId_1260:int = 1260;
      public static const CoreApiId_1261:int = 1261;
      public static const CoreApiId_1262:int = 1262;
      public static const CoreApiId_1263:int = 1263;
      
      public static const CoreApiId_1280:int = 1280;
      
      public static const CoreApiId_1400:int = 1400; // entity.shape
      public static const CoreApiId_1401:int = 1401; // entity.shape
      public static const CoreApiId_1402:int = 1402; // entity.shape
      public static const CoreApiId_1403:int = 1403; // entity.shape
      public static const CoreApiId_1404:int = 1404; // entity.shape
      public static const CoreApiId_1405:int = 1405; // entity.shape

      
      public static const CoreApiId_1550:int = 1550; // entity.text
      public static const CoreApiId_1551:int = 1551; // entity.text
      public static const CoreApiId_1552:int = 1552; // entity.text
      public static const CoreApiId_1553:int = 1553; // entity.text
      
      public static const CoreApiId_1990:int = 1990; // joint
      public static const CoreApiId_1991:int = 1991; // joint
      
      public static const CoreApiId_2000:int = 2000; // joint.hinge
      //public static const CoreApiId_2001:int = 2001; // joint.hinge
      public static const CoreApiId_2004:int = 2004; // joint.hinge
      //public static const CoreApiId_2005:int = 2005; // joint.hinge
      public static const CoreApiId_2006:int = 2006; // joint.slider
      public static const CoreApiId_2007:int = 2007; // joint.slider
      
      public static const CoreApiId_2030:int = 2030; // joint.slider
      public static const CoreApiId_2031:int = 2031; // joint.slider
      public static const CoreApiId_2032:int = 2032; // joint.slider
      public static const CoreApiId_2033:int = 2033; // joint.slider
      
      //public static const CoreApiId_2500:int = 2500; // trigger.timer
      public static const CoreApiId_2501:int = 2501; // trigger.timer
      //public static const CoreApiId_2502:int = 2502; // trigger.timer
      public static const CoreApiId_2503:int = 2503; // trigger.timer
      //public static const CoreApiId_2504:int = 2504; // trigger.timer
      //public static const CoreApiId_2505:int = 2505; // trigger.timer
      
   //=============================================================
      
      public static const NumPlayerFunctions:int = 3000;

   }
}