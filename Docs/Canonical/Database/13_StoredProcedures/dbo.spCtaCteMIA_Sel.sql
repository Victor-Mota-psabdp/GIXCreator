SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[spCtaCteMIA_Sel]  
  
 @Processo  varchar(16)  
  
AS  
 SELECT  
  TT.Nome_tp_tx   TAXA,  
  CC.DC_MIA    DC,  
  PS.apelido    PESSOA,  
  TM.nome_tp_moeda  MOEDA,  
  vlr_org_MIA   VALOR,  
  dt_prev_pgto_MIA  PREVISTA,  
  Dt_Ins_MIA    INSERCAO,  
  Comp_CPA_MIA   CPA,  
  CC.Num_DCN_MIA   INVOICE,   
  Org_Ins_MIA   DEPART,  
  CXA.Dt_Pgto_Rcto_HIA Dt_Lcto,  
  CXA.Num_Lcto  NUM_LCTO,  
  CC.Num_NF_MIA   NF,  
  Desp_Org_MIA  ORIGIN,  
  CPMF_MIA   CPMF,  
  Comp_RP_MIA   RP,  
  Comp_DN_MIA   DN,  
  Comp_CN_MIA   CN,  
  Comp_CPA_MIA  CPA,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant) Vlr_Contab,  
  --(Select max(FatCod) from item_Fat FAT where FAT.Num_Proc = CC.num_proc_mia and FAT.cd_tp_tx = CC.cd_tp_tx and FAT.DC = CC.dc_mia and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')) UltimaFatura,  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mia,CC.dc_mia,CC.cd_tp_tx) UltimaFatura,  
    --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
  MAX(AX.ID_AX) as ID_AX
 FROM  
  Cta_Cte_Mas_Imp_Aer CC  
  left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx  
  left join Tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda  
  left join pessoa PS on CC.cd_cred_dev_MIA = PS.cd_pes  
  Left join vwCXAS CXA on CC.num_proc_MIA = CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MIA = CXA.dc_HIA  
  Left join vwAXDocs AX on CC.Num_proc_MIA = AX.NumeroInternoAX  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_MIA = ax.dc  
 WHERE   
  CC.Num_Proc_MIA = @Processo  
  --MARCELA 08/06/2020 #100-229083 tratativa p retirar duplicidade na visualização de taxa
GROUP BY
  TT.Nome_tp_tx,  
  CC.DC_MIA,  
  PS.apelido,  
  TM.nome_tp_moeda,  
  vlr_org_MIA,  
  dt_prev_pgto_MIA,  
  Dt_Ins_MIA,  
  Comp_CPA_MIA,  
  CC.Num_DCN_MIA,   
  Org_Ins_MIA,  
  CXA.Dt_Pgto_Rcto_HIA,  
  CXA.Num_Lcto,  
  CC.Num_NF_MIA,  
  Desp_Org_MIA,  
  CPMF_MIA,  
  Comp_RP_MIA,  
  Comp_DN_MIA,  
  Comp_CN_MIA,  
  Comp_CPA_MIA,  
  Isnull(Vlr_Contab, Vlr_Contab_Ant) ,  
  dbo.[FBusca_UltimaFatura](CC.num_proc_mia,CC.dc_mia,CC.cd_tp_tx)  
 ORDER BY  
  1, 2 desc  
  
  
  
  
GO
