SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCheckList_DOW_Rel]--'EMCSR201601001BR','Cadu'
(
	@Processo	varchar(16),
	@NomeUsuario varchar(100)
)

AS
	select
		HOU.Num_Proc										Processo,
		E.Num_CPF_CNPJ										E_CNPJ,
		E.Nome_Raz_Soc										Exportador,
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,1)		Ordem,
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,4)		RE_DI,	
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,12)		DDE,		
		--Caixa Nº:  Informação de tela de Referência do ATL - Tipo de Documento: 030 - Arktec Num
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,30)		Caixa,
		HOU.modal											modal,
		C.Nome_Raz_Soc										Consignatario,
		C.Num_CPF_CNPJ										C_CNPJ,
		(case when D2.Anexado_Em IS Not null then 'X' else '' end)	Invoice,
		(case when D11.Anexado_Em IS Not null then 'X' else '' end)	PackingList,
		(case when D27.Anexado_Em IS Not null then 'X' else '' end)	LaudodeArqueação,
		(case when D20.Anexado_Em IS Not null then 'X' else '' end)	ConhecimentodeEmbarque,
		(case when D4.Anexado_Em IS Not null then 'X' else '' end)	RE,
		(case when D22.Anexado_Em IS Not null then 'X' else '' end)	CertificadodeFumigação,
		(case when D13.Anexado_Em IS Not null then 'X' else '' end) CertificadodeOrigem,
		(case when D102.Anexado_Em IS Not null then 'X' else '' end) CertificadodeAnálise,
		(case when D26.Anexado_Em IS Not null then 'X' else '' end)	DSE,
		(case when D12.Anexado_Em IS Not null then 'X' else '' end)	DDEAverbada,
		(case when D18.Anexado_Em IS Not null then 'X' else '' end)	Riex,
		(case when D10.Anexado_Em IS Not null then 'X' else '' end)	NotaFiscal,
		(case when D36.Anexado_Em IS Not null then 'X' else '' end)	DocumentosBanco,
		(case when D62.Anexado_Em IS Not null then 'X' else '' end)	ComprovantedeExportação,
		(case when D60.Anexado_Em IS Not null then 'X' else '' end)	FaturaBDP,
		@NomeUsuario Nome_Usuario	
						
	from
		vwHouse_Exp	 HOU
		--join Usuario U on U.Cd_Usuario = Hou.Cd_Usuario
		Join Pessoa E	on	E.cd_pes = HOU.Cd_Export
		Join Pessoa C	on	c.cd_pes = HOU.Cd_Consig
		left join Doc_Anexos D2 on D2.num_proc = HOU.num_proc and d2.id_dc = 2
		left join Doc_Anexos D11 on D11.num_proc = HOU.num_proc and D11.id_dc = 11
		left join Doc_Anexos D27 on D27.num_proc = HOU.num_proc and D27.id_dc = 27
		left join Doc_Anexos D20 on D20.num_proc = HOU.num_proc and D20.id_dc = 20
		left join Doc_Anexos D4 on D4.num_proc = HOU.num_proc and D4.id_dc = 4
		left join Doc_Anexos D22 on D22.num_proc = HOU.num_proc and D22.id_dc = 22
		left join Doc_Anexos D13 on D13.num_proc = HOU.num_proc and D13.id_dc = 13
		left join Doc_Anexos D102 on D102.num_proc = HOU.num_proc and D102.id_dc = 102
		left join Doc_Anexos D26 on D26.num_proc = HOU.num_proc and D26.id_dc = 26
		left join Doc_Anexos D12 on D12.num_proc = HOU.num_proc and D12.id_dc = 12
		left join Doc_Anexos D18 on D18.num_proc = HOU.num_proc and D18.id_dc = 18
		left join Doc_Anexos D10 on D10.num_proc = HOU.num_proc and D10.id_dc = 10
		left join Doc_Anexos D36 on D36.num_proc = HOU.num_proc and D36.id_dc = 36
		left join Doc_Anexos D62 on D62.num_proc = HOU.num_proc and D62.id_dc = 62
		left join Doc_Anexos D60 on D60.num_proc = HOU.num_proc and D60.id_dc = 60		
	where
		HOU.Num_Proc = @Processo
		
UNION ALL

	select
		HOU.Num_Proc											Processo,
		E.Num_CPF_CNPJ										E_CNPJ,
		E.Nome_Raz_Soc										Exportador,
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,1)		Ordem,
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,4)		RE_DI,
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,12)		DDE,				
		--Caixa Nº:  Informação de tela de Referência do ATL - Tipo de Documento: 030 - Arktec Num
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,30)		Caixa,
		HOU.modal											modal,
		C.Nome_Raz_Soc										Consignatario,
		C.Num_CPF_CNPJ										C_CNPJ,
		(case when D2.Anexado_Em IS Not null then 'X' else '' end)	Invoice,
		(case when D11.Anexado_Em IS Not null then 'X' else '' end)	PackingList,
		(case when D27.Anexado_Em IS Not null then 'X' else '' end)	LaudodeArqueação,
		(case when D20.Anexado_Em IS Not null then 'X' else '' end)	ConhecimentodeEmbarque,
		(case when D4.Anexado_Em IS Not null then 'X' else '' end)	RE,
		(case when D22.Anexado_Em IS Not null then 'X' else '' end)	CertificadodeFumigação,
		(case when D13.Anexado_Em IS Not null then 'X' else '' end) CertificadodeOrigem,
		(case when D102.Anexado_Em IS Not null then 'X' else '' end) CertificadodeAnálise,
		(case when D26.Anexado_Em IS Not null then 'X' else '' end)	DSE,
		(case when D12.Anexado_Em IS Not null then 'X' else '' end)	DDEAverbada,
		(case when D18.Anexado_Em IS Not null then 'X' else '' end)	Riex,
		(case when D10.Anexado_Em IS Not null then 'X' else '' end)	NotaFiscal,
		(case when D36.Anexado_Em IS Not null then 'X' else '' end)	DocumentosBanco,
		(case when D62.Anexado_Em IS Not null then 'X' else '' end)	ComprovantedeExportação,
		(case when D60.Anexado_Em IS Not null then 'X' else '' end)	FaturaBDP,
		@NomeUsuario Nome_Usuario	
	from
		vwHouse_Imp	 HOU
		--join Usuario U on U.Cd_Usuario = Hou.Cd_Usuario
		Join Pessoa E	on	E.cd_pes = HOU.Cd_Export
		Join Pessoa C	on	c.cd_pes = HOU.Cd_Consig
		left join Doc_Anexos D2 on D2.num_proc = HOU.num_proc and d2.id_dc = 2
		left join Doc_Anexos D11 on D11.num_proc = HOU.num_proc and D11.id_dc = 11
		left join Doc_Anexos D27 on D27.num_proc = HOU.num_proc and D27.id_dc = 27
		left join Doc_Anexos D20 on D20.num_proc = HOU.num_proc and D20.id_dc = 20
		left join Doc_Anexos D4 on D4.num_proc = HOU.num_proc and D4.id_dc = 4
		left join Doc_Anexos D22 on D22.num_proc = HOU.num_proc and D22.id_dc = 22
		left join Doc_Anexos D13 on D13.num_proc = HOU.num_proc and D13.id_dc = 13
		left join Doc_Anexos D102 on D102.num_proc = HOU.num_proc and D102.id_dc = 102
		left join Doc_Anexos D26 on D26.num_proc = HOU.num_proc and D26.id_dc = 26
		left join Doc_Anexos D12 on D12.num_proc = HOU.num_proc and D12.id_dc = 12
		left join Doc_Anexos D18 on D18.num_proc = HOU.num_proc and D18.id_dc = 18
		left join Doc_Anexos D10 on D10.num_proc = HOU.num_proc and D10.id_dc = 10
		left join Doc_Anexos D36 on D36.num_proc = HOU.num_proc and D36.id_dc = 36
		left join Doc_Anexos D62 on D62.num_proc = HOU.num_proc and D62.id_dc = 62
		left join Doc_Anexos D60 on D60.num_proc = HOU.num_proc and D60.id_dc = 60	
	where
		HOU.Num_Proc = @Processo


	
	
	
GO
