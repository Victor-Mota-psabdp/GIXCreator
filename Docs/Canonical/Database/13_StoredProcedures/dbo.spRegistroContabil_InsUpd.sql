SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRegistroContabil_InsUpd]

	@Lancamento varchar(1),
	@Doc		varchar(1),
	@Mes		int,
	@Ano		varchar(4),
	@Companhia	varchar(30),
	@RUT		varchar(14),
	@Registro	varchar(6),
	@DtEmissao	datetime,
	@DtVenc		datetime,
	@Moeda		varchar(20),
	@ValorTC	float,
	@Isento		varchar(1),
	@TipoFat	varchar(1),
	@Tipo		varchar(50),
	@DocNumber	Varchar(60),
	@ClienteSeguro	Varchar(30),
	@CNPJSeguro		varchar(14),

	@Habilita_Impostos bit,
	@Ref_Acesso char(1),

	@cd_servico int,
    @Item_lei varchar(10),	

	@RegN		int output


 AS

	Begin Transaction

		Declare @Cd_Moeda as varchar(3)
		Declare @Cd_Companhia as varchar(10)
		Declare @Cd_Cliente_Seguro Varchar(10)

		set @Cd_Moeda = (select Cd_Tp_Moeda from tipo_moeda where nome_tp_moeda = @Moeda)
		set @Cd_Companhia = (select Cd_Pes from pessoa where apelido = @Companhia)
		set @Cd_Cliente_Seguro=(select Cd_Pes from pessoa where apelido = @Companhia)

		if @Registro is null
			begin
				set @Registro = (Select isnull(max(Num_registro),0) from registro_financeiro where Mes = @Mes and Ano = @Ano) + 1
				set @Registro = right(('00000'+@Registro),6)
				insert into 
					Registro_Financeiro(
					Cd_Pes,
					Num_CNPJ,
					Mes,
					Ano,
					Num_Registro,
					Cd_Tipo_Lanc,
					Dt_Ins,
					Dt_Venc,
					Isento,
					Cd_Tp_Moeda,
					Par_Moeda,
					Cd_Regra,
					Cd_Tp_Fatura,
					Cd_Tp_Doc,
					Doc_Number,
					Cd_Pes_Seguro,
					NUM_CNPJ_Seguro,
					Habilita_Impostos,
					Ref_Acesso,
					ativo,
					cd_servico,
					Item_lei
					)
				Values
					(
					@Cd_Companhia,
					@RUT,
					@Mes,
					@Ano,
					@Registro,
					@Lancamento,
					@DtEmissao,
					@DtVenc,
					@Isento,
					@Cd_Moeda,
					@ValorTC,
					@Tipo,
					@TipoFat,
					@Doc,
					@DocNumber,
					@Cd_Cliente_Seguro,
					@CNPJSeguro,
					@Habilita_Impostos,
					@Ref_Acesso,
					1,
					@cd_servico,
				    @Item_lei
					)

				set @RegN = @Registro

			end
		else
			begin
				update
					Registro_Financeiro
				set
					Cd_Pes_Seguro=@Cd_Cliente_Seguro,
					Cd_Pes=@Cd_Companhia,
					Num_CNPJ=@RUT,
					Cd_Tipo_Lanc=@Lancamento,
					Dt_Ins=@DtEmissao,
					Dt_Venc=@DtVenc,
					Isento=@Isento,
					Cd_Tp_Moeda=@Cd_Moeda,
					Par_Moeda=@ValorTC,
					Cd_Regra=@Tipo,
					Cd_Tp_Fatura=@TipoFat,
					Cd_Tp_Doc=@Doc,
					Doc_Number=@DocNumber,
					NUM_CNPJ_Seguro=@CNPJSeguro,
					Habilita_Impostos = @Habilita_Impostos,
					Ref_Acesso = @Ref_Acesso,
					cd_servico = @cd_servico,
					Item_lei = @Item_lei
				where
					Mes = @Mes and Ano = @Ano and Num_Registro = @Registro

				set @RegN = @Registro
			end

	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

	Commit Transaction 		
		



GO
