SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spDemurrageG_Rel]--'01-01-2012','03-24-2010'
	@Data Char(10)--,
	--@Hoje	Char(10)
as

Select
	DT_Atrac_mim , upper(Nome_Armador), Navio_mim, Viagem_mim,
	Dst.Nome_Local Destino, Upper(PP.Apelido) Pessoa,Hawb_him  House, 
	Nome_tp_cont, Num_cont_im, Dt_devol_im, isnull(Dt_Vcto_Devol_IM,'01/01/2010') Dt_Vcto_Devol_IM,Mawb_mim,
	org.Nome_Local Origem, sh.apelido Shipper,sum(isnull(vlr_pgto_rcto_him,0))Garantia,DataDevCli_IM,
	dbo.FDemurrage_Fat(hou.num_proC_him) Faturado,
	hou.num_proc_him,idm_Tx,
	dbo.fDem_Dias(hou.num_proc_him,Num_cont_im) Dias_Cobrados,
	dbo.fCC_IM(hou.num_proc_him) Qty, Par_Moeda
from
	master_imp_mar MAS
	Join Localidade DST on DST.cd_local=cd_dst_mim
	Join House_imp_mar hou on hou.num_proc_mim=mas.num_proc_mim
	Join Pessoa PP on PP.cd_pes=cd_consig_him
	left Join Armador ARM on ARM.cd_armador=MAS.cd_armador
	Join Container_mas_imp_mar CM on CM.num_proc_mim=mas.num_proc_mim
	Join Container_hou_imp_mar CH on CH.num_proc_mim=CM.NUM_PROC_MIM AND CH.Item_Cont_IM=Cm.Item_Cont_IM and ch.num_proc_him=hou.num_proc_him
	Join Tipo_container TC on TC.cd_tp_cont=cm.cd_tp_cont
	Join Localidade Org on Org.cd_local=cd_org_him
	Join Pessoa Sh on Sh.cd_pes=cd_export_him
	Left Join item_demurrage IDE on CM.cd_tp_cont=IDE.cd_tp_cont and IDM_Per_FIM=999 and IDE.cd_armador='BDP'
	Left Join Caixa_hou_imp_Mar CXA on hou.num_proc_him=cxa.num_proc_him and cxa.cd_tp_Tx in ('DD2','DDG') and cxa.dc_him='C'
	Left Join Paridade PAR on PAR.cd_tp_moeda='USD' and converT(datetime,dt_par,105)=dbo.hoje(getdate()) and par.cd_tp_par='OFC'
	LEft Join LLP_Master LLPM on mas.num_proc_mim=LLPM.num_proc_master
Where

	cm.cd_tp_cont not in ('LCL','LCM') and 
	(convert(datetime,dt_atrac_mim,105)>=@Data or ETA_Master >=@Data) and cd_consig_mim in ('10018','10017','110077','P13313','P11355')
	and (len(dt_devol_im)=0 or dt_devol_im is null)	
	and hou.num_proc_him not in 
	(
'IMNVS20100400101',
'IMRIG20070700301',
'IMSSZ20070409401',
'IMSSZ20070409501',
'IMSSZ20070409601',
'IMSSZ20070409701',
'IMSSZ20070409801',
'IMSSZ20070604701',
'IMSSZ20070604801',
'IMSSZ20070604901',
'IMSSZ20070605001',
'IMSSZ20070605101',
'IMSSZ20070605201',
'IMSSZ20070612201',
'IMSSZ20070701001',
'IMSSZ20070701101',
'IMSSZ20070701201',
'IMSSZ20070702001',
'IMSSZ20070704901',
'IMSSZ20070706101',
'IMSSZ20070706901',
'IMSSZ20070707501',
'IMSSZ20070707601',
'IMSSZ20070802301',
'IMSSZ20070802401',
'IMSSZ20070802501',
'IMSSZ20070805201',
'IMSSZ20070805301',
'IMSSZ20070805401',
'IMSSZ20070805501',
'IMSSZ20070900501',
'IMSSZ20070900601'
) and (convert(datetime,dt_atrac_mim,105)<=getdate() or ETA_MASTER<=getdate())

GROUP BY
	DT_Atrac_mim, (Nome_Armador), Navio_mim, Viagem_mim,
	Dst.Nome_Local , (PP.Apelido) ,Hawb_him , 
	Nome_tp_cont, Num_cont_im, Dt_devol_im, Dt_Vcto_Devol_IM,Mawb_mim,
	org.Nome_Local , sh.apelido, DataDevCli_IM,hou.num_proc_him,IDM_TX, Par_Moeda	,eta_master

order by convert(datetime,dt_atrac_mim,105) desc












GO
