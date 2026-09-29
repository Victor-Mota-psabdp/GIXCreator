SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaProcessoACASINT_Teste_Sel]



as

Select 1029 ID,num_proc_hea Processo,'AC' Type,GETDATE() Dt_Ins,NULL  Dt_Send,'CE' CD_USUARIO, '9' Tipo_Envio 
From House_exp_aer HOU with(nolock)
join llp_exp_aer LLP with(nolock) on  LLP.num_proc_lea=hou.num_proc_hea
Left Join Exchange_ACAS E with(nolock) on num_proc_hea=num_proc
Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hea
where
--	ETD_LEA >=getdate()-7
	--and num_proc is null
	--and 
	num_proc_mea <>'JOB'
	and cd_pais='US'
	
and HOU.Num_Proc_HEA in 
(
'EAATL201805008BR')
--AC	2019-03-28 15:30:21.693	2019-03-29 13:59:00.447	ERBSON	9

--1019	EACSR201801001BR	AC	2018-09-13 14:32:01.460	2018-09-14 17:01:05.463	ERBSON	9
--1020	EACSR201806005BR	AC	2018-09-24 15:45:04.570	2018-09-24 15:52:09.893	ERBSON	9
--1021	EAATL201806002BR	AC	2018-09-24 15:52:51.817	2018-09-24 15:53:26.007	ERBSON	9
--1022	EASGB201804001BR	AC	2019-03-28 15:30:21.693	2019-03-29 13:59:00.447	ERBSON	9

--select ID, Num_Proc Processo, Type,Dt_Ins, Dt_Send,Cd_Usuario,Tipo_Envio from Exchange_GTNEXUS with (nolock)
--where Dt_Send is null and Type = @Type 

--select * from Exchange_ACAS where  num_proc
-- in 
--('EAATL201809024BR',
--'EACER201810001BR',	
--'EAEAS201806001BR',	
--'EAATL201805008BR',	
--'EAATL201808002BR',	
--'EAATL201808029BR')
	
	


GO
