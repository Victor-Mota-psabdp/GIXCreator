SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Registro_Financeiro
CREATE procedure [dbo].[spATL_Registro_Financeiro_InsUpd]
(
	@ID							int,
	@Cd_Pes						varchar(10),
	@NUM_CNPJ					varchar(14),
	@Mes						int,
	@Ano						int,
	@Num_Registro				varchar(6),
	@Cd_Tipo_Lanc				varchar(1),
	@Dt_Ins						datetime,
	@Dt_Venc					datetime,
	@Isento						varchar(1),
	@Cd_Tp_Moeda				varchar(3),
	@Par_Moeda					float,
	@Cd_Regra					varchar(50),
	@Cd_Tp_Fatura				varchar(1),
	@Cd_Tp_Doc					varchar(1),
	@Doc_Number					Varchar(60),
	@Total						decimal(9,2),
	@IVA_Retencoes				decimal(9,2),
	@Total_Doc					decimal(9,2),
	@Cd_Pes_Seguro				Varchar(10),
	@NUM_CNPJ_Seguro			varchar(14),
	@Ativo						Bit,
	@Valor_Total_Moeda_Local	float,
	@Habilita_Impostos			bit,
	@Ref_Acesso					char(1),
	@cd_servico					int,
    @Item_lei					varchar(50),	
	@RegN						int output
)

 AS
	Begin Transaction

		if @Num_Registro is null
			begin
				set @Num_Registro = (Select isnull(max(Num_registro),0) from registro_financeiro where Mes = @Mes and Ano = @Ano) + 1
				set @Num_Registro = right(('00000'+@Num_Registro),6)
				insert into Registro_Financeiro
					(
						ID,Cd_Pes,NUM_CNPJ,Mes,Ano,Num_Registro,Cd_Tipo_Lanc,Dt_Ins,Dt_Venc,Isento,Cd_Tp_Moeda,
						Par_Moeda,Cd_Regra,Cd_Tp_Fatura,Cd_Tp_Doc,Doc_Number,Total,IVA_Retencoes,Total_Doc,Cd_Pes_Seguro,
						NUM_CNPJ_Seguro,Ativo,Valor_Total_Moeda_Local,Habilita_Impostos,Ref_Acesso,Cd_Servico,Item_Lei
					)
				Values
					(
						@ID,@Cd_Pes,@NUM_CNPJ,@Mes,@Ano,@Num_Registro,@Cd_Tipo_Lanc,@Dt_Ins,@Dt_Venc,@Isento,@Cd_Tp_Moeda,
						@Par_Moeda,@Cd_Regra,@Cd_Tp_Fatura,@Cd_Tp_Doc,@Doc_Number,@Total,@IVA_Retencoes,@Total_Doc,@Cd_Pes_Seguro,
						@NUM_CNPJ_Seguro,@ativo,@Valor_Total_Moeda_Local,@Habilita_Impostos,@Ref_Acesso,@cd_servico,@Item_lei
					)

				set @RegN = @Num_Registro

			end
		else
			begin
				update
					Registro_Financeiro
				set					
					Cd_Pes=@Cd_Pes,
					NUM_CNPJ=@NUM_CNPJ,
					Cd_Tipo_Lanc=@Cd_Tipo_Lanc,
					Dt_Ins=@Dt_Ins,
					Dt_Venc=@Dt_Venc,
					Isento=@Isento,
					Cd_Tp_Moeda=@Cd_Tp_Moeda,
					Par_Moeda=@Par_Moeda,
					Cd_Regra=@Cd_Regra,
					Cd_Tp_Fatura=@Cd_Tp_Fatura,
					Cd_Tp_Doc=@Cd_Tp_Doc,
					Doc_Number=@Doc_Number,
					Total=@Total,
					IVA_Retencoes=@IVA_Retencoes,
					Total_Doc=@Total_Doc,
					Cd_Pes_Seguro=@Cd_Pes_Seguro,
					NUM_CNPJ_Seguro=@NUM_CNPJ_Seguro,
					ativo=@ativo,
					Valor_Total_Moeda_Local=@Valor_Total_Moeda_Local,
					Habilita_Impostos=@Habilita_Impostos,
					Ref_Acesso=@Ref_Acesso,
					cd_servico=@cd_servico,
					Item_lei=@Item_lei
				where
					Mes = @Mes and Ano = @Ano and Num_Registro = @Num_Registro

				set @RegN = @Num_Registro
			end

	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

	Commit Transaction 		
		



GO
