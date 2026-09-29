SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select GETDATE()
--[dbo].[spDemurrageATL_InsUpd] 'IMFMC201712020BR','C','FMC QUIMICA - 2987C','31/12/2017','23/02/2018',
--'USD','208','0,00',Null,
--'SAN ANTONIO EXPRESS','BRAEM1217003','04136367000430','F','2018-02-14 12:45:47.093','3,5112','0,00',Null

--sp_help demurrage_ATL
CREATE  procedure [dbo].[spDemurrageATL_InsUpd]
		@Processo	VarChar(16),
		@Fatura		Char(1),
		@Apelido	VarChar(60),
		@Atracacao	VarChar(10),
		@Vencimento	VarChar(10),
		@Moeda		Char(3),
		@Valor		float,
		@Desconto	Float,
		@Desc_Obs	VarChar(100),
		@Navio		VarChar(25),
		@HBL		VarChar(25),
		@CNPJ		VarChar(14),
		@Tipo		Char(1),
		@Dt_Emis	Datetime,
		@paridade	float,
		@Garantia	float,
		@Status_Descricao	VarChar(200)

as
	
	declare @seq int
	
	declare @ID_Status bigint
	if @Status_Descricao = null
		set @ID_Status = 2
	else	
		set @ID_Status = (select ID_Status  from Tipo_Status_Demurrage with(nolock) where Status_Descricao = @Status_Descricao)
	
	declare @cd_pes varchar(10)
	set @cd_pes = (select cd_pes from Pessoa with(nolock) where Apelido = @Apelido)
	

	if @TIPO = 'P'				
			if not exists(select isnull(max(seq),0) from demurrage_atl where processo = @Processo and tipo <> 'C')
				set @seq = 1
			else
				set @seq = (select isnull(max(seq),0) from demurrage_atl where processo = @Processo and tipo <> 'C') + 1	

	if @TIPO = 'F'				
			if not exists(select isnull(max(seq),0) from demurrage_atl where processo = @Processo and fatura = @fatura and tipo <> 'C')
				set @seq = 1
			else
				set @seq = (select isnull(max(seq),0) from demurrage_atl where processo = @Processo and fatura = @fatura and tipo <> 'C') + 1
		
	
	if not exists(select processo from demurrage_ATL where processo=@processo and fatura=@fatura)
		BEGIN

			insert demurrage_ATL
				(
					Processo,Fatura,Apelido,Atracacao,Vencimento,Moeda,Valor,Desconto,Desc_Obs,
					Navio,HBL,CNPJ,Tipo,Dt_Emis,Paridade,Garantia,seq,ID_Status,dt_alter,cd_pes
				)
			Values
				(
					@Processo,@Fatura,@Apelido,@Atracacao,@Vencimento,@Moeda,@Valor,@Desconto,@Desc_Obs,
					@Navio,@HBL,@CNPJ,@Tipo,@Dt_Emis,@paridade,@Garantia,@seq,2,GETDATE(),@cd_pes
					--cria como invoiced
				)
		END
	else
		UPDATE
			DEMURRAGE_ATL
				SET
					Apelido=@Apelido,
					Atracacao=@Atracacao,
					Vencimento=@Vencimento,
					Moeda=@Moeda,
					Valor=@Valor,
					Desconto=@Desconto,
					Desc_Obs=@Desc_Obs,
					Navio=@Navio,
					HBL=@HBL,
					CNPJ=@CNPJ,
					Tipo=@Tipo,
					Dt_Emis=@Dt_Emis,
					Paridade=@paridade,
					Garantia=@Garantia,
					--seq = @seq,
					ID_Status = @ID_Status,
					dt_alter = GETDATE()
					--dt_envio = NULL					
			WHERE
				processo=@processo and fatura=@fatura
				
				
				
--ALTER procedure [dbo].[spDemurrageATL_InsUpd]
--		@Processo	VarChar(16),
--		@Fatura		Char(1),
--		@Apelido	VarChar(60),
--		@Atracacao	VarChar(10),
--		@Vencimento	VarChar(10),
--		@Moeda		Char(3),
--		@Valor		float,
--		@Desconto	Float,
--		@Desc_Obs	VarChar(100),
--		@Navio		VarChar(25),
--		@HBL		VarChar(25),
--		@CNPJ		VarChar(14),
--		@Tipo		Char(1),
--		@Dt_Emis	Datetime,
--		@paridade	float,
--		@Garantia	float

--as
	
--	declare @seq int

--	if @TIPO = 'P'				
--			if not exists(select isnull(max(seq),0) from demurrage_atl where processo = @Processo and tipo <> 'C')
--				set @seq = 1
--			else
--				set @seq = (select isnull(max(seq),0) from demurrage_atl where processo = @Processo and tipo <> 'C') + 1	

--	if @TIPO = 'F'				
--			if not exists(select isnull(max(seq),0) from demurrage_atl where processo = @Processo and fatura = @fatura and tipo <> 'C')
--				set @seq = 1
--			else
--				set @seq = (select isnull(max(seq),0) from demurrage_atl where processo = @Processo and fatura = @fatura and tipo <> 'C') + 1
		
	
--	if not exists(select processo from demurrage_ATL where processo=@processo and fatura=@fatura)
--		BEGIN

--			insert demurrage_ATL
--				(
--					Processo,Fatura,Apelido,Atracacao,Vencimento,Moeda,Valor,Desconto,Desc_Obs,Navio,HBL,CNPJ, Tipo,Dt_Emis,Paridade,Garantia,seq
--				)
--			Values
--				(
--					@Processo,@Fatura,@Apelido,@Atracacao,@Vencimento,@Moeda,@Valor,@Desconto,@Desc_Obs,@Navio,@HBL,@CNPJ,@Tipo,@Dt_Emis,@paridade,@Garantia,@seq
--				)
--		END
--	else
--		UPDATE
--			DEMURRAGE_ATL
--				SET
--					Apelido=@Apelido,
--					Atracacao=@Atracacao,
--					Vencimento=@Vencimento,
--					Moeda=@Moeda,
--					Valor=@Valor,
--					Desconto=@Desconto,
--					Desc_Obs=@Desc_Obs,
--					Navio=@Navio,
--					HBL=@HBL,
--					CNPJ=@CNPJ,
--					Tipo=@Tipo,
--					Dt_Emis=@Dt_Emis,
--					Paridade=@paridade,
--					Garantia=@Garantia,
--					seq = @seq
--			WHERE
--				processo=@processo and fatura=@fatura







GO
