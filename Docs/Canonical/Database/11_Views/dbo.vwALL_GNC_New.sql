SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vwALL_GNC_New]
as
Select 
AJ.Num_Proc										[BDP REF.],
HGI.HSGData										[REGISTRO GNC],
TPNC.Cd_NC										[GNC CODE],
TPNC.Parte_Resp									[RESP. PART],
TPNC.Descricao_nC								[NC DESC],
TPNC.Descricao_NC_ENG							[NC DESC ENG],
TPNC.Descricao_NC_PTG							[NC DESC PTG],
HGI.HSDDescricao								[HISTORICO GNC],
HGI.HSGDataFU									[DT. PREVISAO],
TPO.Nome_Tp_Ocor								[TIPO DE OCORRENCIA],
HGI.HSGData										[DT. REGISTRO]


from 
vwCliente_Alerta				AJ		with(nolock)
JOIN Pessoa_LLP					LLP		with(NOLOCK)	 on		LLP.Cd_Pes		= AJ.cd_cliente
join Hist_Geral					HGI		with(nolock)	 on		AJ.Num_Proc		= HGI.HSGProcesso 
Join Tipo_NC_Cliente			TPNC	with(nolock)	 on		tpnc.Cd_NC		= hgi.id_nc and (TPNC.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo or TPNC.Cd_Pes_Grupo= '10017') and Ativo = 'S'
Join  tipo_ocorrencia			TPO		with(nolock)	 on		TPO.Cd_Tp_Ocor	= HGI.Cd_Tp_Ocor

where
	--AJ.Num_Proc =  'EMOXT202403035BR'
	convert(datetime,HGI.HSGData,105) >= getdate()-1000







GO
