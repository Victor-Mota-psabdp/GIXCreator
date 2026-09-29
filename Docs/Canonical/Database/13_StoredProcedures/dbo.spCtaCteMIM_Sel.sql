SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
 CREATE PROCEDURE [dbo].[spCtaCteMIM_Sel]  
  
 @Processo  varchar(16)  
  
AS  
 SELECT  
  TT.Nome_tp_tx   TAXA,  
  CC.DC_MIM    DC,  
  PS.apelido    PESSOA,  
  TM.nome_tp_moeda  MOEDA,  
  vlr_org_MIM   VALOR,  
  dt_prev_pgto_MIM  PREVISTA,  
  Dt_Ins_MIM    INSERCAO,  
  Comp_CPA_MIM   CPA,  
  CC.Num_DCN_MIM   INVOICE,   
  Org_Ins_MIM   DEPART,  
  CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,  
  CXA.Num_Lcto  NUM_LCTO,  
  CC.Num_NF_MIM   NF,  
  Desp_Org_MIM  ORIGIN,  
  CPMF_MIM   CPMF,  
  Comp_RP_MIM   RP,  
  Comp_DN_MIM   DN,  
  Comp_CN_MIM   CN,  
  Comp_CPA_MIM  CPA,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant) Vlr_Contab,  
  --(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_mim and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_mim and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mim,CC.dc_mim,CC.cd_tp_tx) UltimaFatura,  
    --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
  MAX(AX.ID_AX) as ID_AX
 FROM  
  Cta_Cte_Mas_Imp_Mar CC  
  left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx  
  left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left join pessoa PS on CC.cd_cred_dev_MIM = PS.cd_pes  
  Left join vwCXAS CXA on CC.num_proc_MIM = CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MIM = CXA.dc_HIA  
  Left join vwAXDocs AX on CC.Num_proc_MIM = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MIM = ax.dc  
 WHERE   
  CC.Num_Proc_MIM = @Processo  
    --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
  GROUP BY 
    TT.Nome_tp_tx,  
  CC.DC_MIM,  
  PS.apelido,  
  TM.nome_tp_moeda,  
  vlr_org_MIM,  
  dt_prev_pgto_MIM,  
  Dt_Ins_MIM,  
  Comp_CPA_MIM,  
  CC.Num_DCN_MIM,   
  Org_Ins_MIM,  
  CXA.Dt_Pgto_Rcto_HIA,  
  CXA.Num_Lcto,  
  CC.Num_NF_MIM,  
  Desp_Org_MIM,  
  CPMF_MIM,  
  Comp_RP_MIM,  
  Comp_DN_MIM,  
  Comp_CN_MIM,  
  Comp_CPA_MIM,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant) ,  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mim,CC.dc_mim,CC.cd_tp_tx) 
 ORDER BY  
  1, 2 desc  
  
  
  
GO
