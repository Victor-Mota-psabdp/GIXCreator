SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE [dbo].[spCtaCteMEA_Sel]--'EAGRU201307001'    
    
 @Processo  varchar(16)    
    
AS    
 SELECT    
  TT.Nome_tp_tx   TAXA,    
  CC.DC_MEA    DC,    
  PS.apelido    PESSOA,    
  TM.nome_tp_moeda  MOEDA,    
  vlr_org_MEA   VALOR,    
  dt_prev_pgto_MEA  PREVISTA,    
  Dt_Ins_MEA    INSERCAO,    
  Comp_CPA_MEA   CPA,    
  CC.Num_DCN_MEA   INVOICE,     
  Org_Ins_MEA   DEPART,    
  CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,    
  CXA.Num_Lcto  NUM_LCTO,    
  CC.Num_NF_MEA   NF,    
  Desp_Dst_MEA  Desp,    
  CPMF_MEA   CPMF,    
  Comp_RP_MEA   RP,    
  Comp_DN_MEA   DN,    
  Comp_CN_MEA   CN,    
  Comp_CPA_MEA  CPA,    
  Isnull(Vlr_Contab, Vlr_Contab_Ant) Vlr_Contab,    
  --(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_mea and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_mea and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,    
  dbo.[FBusca_UltimaFatura](CC.num_proc_mea,CC.dc_mea,CC.cd_tp_tx) UltimaFatura,    
  --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa  
  MAX(AX.ID_AX)  as ID_AX
 FROM    
  Cta_Cte_Mas_Exp_Aer CC    
  left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx    
  left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda    
  left join pessoa PS on CC.cd_cred_dev_MEA = PS.cd_pes    
  Left join vwCXAS CXA on CC.num_proc_MEA = CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MEA = CXA.dc_HIA    
  Left join vwAXDocs AX on CC.Num_proc_MEA = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MEA = ax.dc    
 WHERE     
  CC.Num_Proc_MEA = @Processo    
  --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa  
  GROUP BY  
 TT.Nome_tp_tx ,    
  CC.DC_MEA,    
  PS.apelido,    
  TM.nome_tp_moeda,    
  vlr_org_MEA,    
  dt_prev_pgto_MEA,    
  Dt_Ins_MEA,    
  Comp_CPA_MEA,    
  CC.Num_DCN_MEA,     
  Org_Ins_MEA,    
  CXA.Dt_Pgto_Rcto_HIA,    
  CXA.Num_Lcto ,    
  CC.Num_NF_MEA,    
  Desp_Dst_MEA,    
  CPMF_MEA,    
  Comp_RP_MEA,    
  Comp_DN_MEA,    
  Comp_CN_MEA,    
  Comp_CPA_MEA,    
  Isnull(Vlr_Contab, Vlr_Contab_Ant) ,    
  dbo.[FBusca_UltimaFatura](CC.num_proc_mea,CC.dc_mea,CC.cd_tp_tx)   
  ORDER BY    
  1, 2 desc    
    
    
    
    
    
GO
