SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [spCheckList_Rel]

(
@Processo	varchar(16)
)

AS
	
	select
			Num_Proc_HIM										Processo,
			Num_CPF_CNPJ										CNPJ,
			Apelido												Importador,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,1)	Ordem,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,5)	DI,
			'OCEAN'												modal
	from
			House_Imp_Mar	 HOU
			Join Pessoa P	on	P.cd_pes = HOU.cd_import_him
	where
			Num_Proc_HIM = @Processo

Union all

	select
			Num_Proc_HIA										Processo,
			Num_CPF_CNPJ										CNPJ,
			Apelido												Importador,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,1)	Ordem,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,5)	DI,
			'AIR'												modal
	from
			House_Imp_Aer	 HOU
			Join Pessoa P	on	P.cd_pes = HOU.cd_import_hia
	where
			Num_Proc_HIA = @Processo

Union all

	select
			Num_Proc_HIO										Processo,
			Num_CPF_CNPJ										CNPJ,
			Apelido												Importador,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,1)	Ordem,
			dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,5)	DI,
			'OTHER'												modal
	from
			House_Imp_Out	 HOU
			Join Pessoa P	on	P.cd_pes = HOU.cd_import_hio
	where
			Num_Proc_HIO = @Processo
	
GO
