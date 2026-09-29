SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[spCtaCteMEM_Sel]  
  
 @Processo  varchar(16)  
  
AS  
 SELECT  
  TT.Nome_tp_tx   TAXA,  
  CC.DC_MEM    DC,  
  PS.apelido    PESSOA,  
  TM.nome_tp_moeda  MOEDA,  
  vlr_org_MEM   VALOR,  
  dt_prev_pgto_MEM  PREVISTA,  
  Dt_Ins_MEM    INSERCAO,  
  Comp_CPA_MEM   CPA,  
  CC.Num_DCN_MEM   INVOICE,   
  Org_Ins_MEM   DEPART,  
  CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,  
  CXA.Num_Lcto  NUM_LCTO,  
  CC.Num_NF_MEM   NF,  
  Desp_Dst_MEM  ORIGIN,  
  CPMF_MEM   CPMF,  
  Comp_RP_MEM   RP,  
  Comp_DN_MEM   DN,  
  Comp_CN_MEM   CN,  
  Comp_CPA_MEM  CPA,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant) Vlr_Contab,  
  --(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_mem and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_mem and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mem,CC.dc_mem,CC.cd_tp_tx) UltimaFatura,  
    --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
  MAX(AX.ID_AX) as ID_AX
 FROM  
  Cta_Cte_Mas_EXP_Mar CC  
  left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx  
  left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left join pessoa PS on CC.cd_cred_dev_MEM = PS.cd_pes  
  Left join vwCXAS CXA on CC.num_proc_MEM = CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MEM = CXA.dc_HIA  
  Left join vwAXDocs AX on CC.Num_proc_MEM = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MEM = ax.dc  
 WHERE   
  CC.Num_Proc_MEM = @Processo  
    --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
  GROUP BY
    TT.Nome_tp_tx,  
  CC.DC_MEM,  
  PS.apelido,  
  TM.nome_tp_moeda,  
  vlr_org_MEM,  
  dt_prev_pgto_MEM,  
  Dt_Ins_MEM,  
  Comp_CPA_MEM,  
  CC.Num_DCN_MEM,   
  Org_Ins_MEM,  
  CXA.Dt_Pgto_Rcto_HIA,  
  CXA.Num_Lcto,  
  CC.Num_NF_MEM,  
  Desp_Dst_MEM,  
  CPMF_MEM,  
  Comp_RP_MEM,  
  Comp_DN_MEM,  
  Comp_CN_MEM,  
  Comp_CPA_MEM,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant),  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mem,CC.dc_mem,CC.cd_tp_tx) 
  ORDER BY  
  1, 2 desc  
  
  
  
  
GO
