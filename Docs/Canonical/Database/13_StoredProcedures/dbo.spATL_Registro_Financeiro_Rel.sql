SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Registro_Financeiro_Rel]--'00 - This Month','This Year','1'
	@Mes varchar(30),
	@Ano varchar(30),
	@Tipo varchar(50)		--	0 - Normal / 1 - Detalhado do Mes-Ano

as

	if @Mes = '00 - This Month'
		set @mes = month(Getdate())
	else
		set @Mes  = convert(int,left(@mes,2))
	if @ano = 'This Year'
		set @Ano = year(getdate())
	else
		set @Ano = convert(int,@Ano)		

	set @Tipo = left(@Tipo,1)

	if @Tipo = 1
		Begin
			select 
				Num_registro [Number],Mes [Mes],Ano [Ano],Apelido [Razao Social],Doc_Number[Documento],cd_Tp_moeda Moeda,total, [dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total [Valor Em Reais - Estimado] 
			from 
				registro_financeiro RF With(nolock)
				Join Pessoa PP With(nolock) on pp.cd_pes=RF.cd_pes
			Where
				Total is not null
				and mes=@mes and ano=@ano
				and ativo = 1		

			Union All

			select 
				'TOTAL','','','','','',0, sum([dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total) 
			from 
				registro_financeiro RF With(nolock)
				Join Pessoa PP With(nolock) on pp.cd_pes=RF.cd_pes
			Where
				Total is not null
				and mes=@mes and ano=@ano
				and ativo = 1
		End
	Else
		Begin		
			select 
				Apelido [Razao Social],Doc_Number[Documento],cd_Tp_moeda Moeda,total, [dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total [Valor Em Reais - Estimado] 
			from 
				registro_financeiro RF With(nolock)
				Join Pessoa PP With(nolock) on pp.cd_pes=RF.cd_pes
			Where
				Total is not null
				and mes=month(Getdate()) and ano=year(getdate())
				and ativo = 1
			
			Union All
			
			
			select 
				'TOTAL','','',0, sum([dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total) 
			from 
				registro_financeiro RF With(nolock)
				Join Pessoa PP With(nolock) on pp.cd_pes=RF.cd_pes
			Where
				Total is not null
				and mes=month(Getdate()) and ano=year(getdate())
				and ativo = 1
		End



--Original
--	select 
--		Apelido [Razao Social],Doc_Number[Documento],cd_Tp_moeda Moeda,total, [dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total [Valor Em Reais - Estimado] 
--			from 
--				registro_financeiro RF
--				Join Pessoa PP on pp.cd_pes=RF.cd_pes
--			Where
--				Total is not null
--				and mes=month(Getdate()) and ano=year(getdate())
--			
--			Union All
--			
--			
--			select 
--				'TOTAL','','',0, sum([dbo].[FConverterMoeda](Cd_Tp_Moeda,'REL')*total) 
--			from 
--				registro_financeiro RF
--				Join Pessoa PP on pp.cd_pes=RF.cd_pes
--			Where
--				Total is not null
--				and mes=month(Getdate()) and ano=year(getdate())
--
--

GO
