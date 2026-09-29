SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_BLSALL_Sel]'','LA', '2013-03-01','2013-03-15'
CREATE procedure [dbo].[spATL_BLSALL_Sel]
	@JOB varchar(16),
	@Tipo varchar(50), --DA,FAT
	@DataInicial datetime,
	@DataFinal datetime
	
AS
		IF @Tipo = 'Nota Fiscal'
			Set @Tipo = 'NF'
		IF @Tipo = 'Provisão'
			Set @Tipo = 'PROV'
		IF @Tipo = 'FATURA'
			Set @Tipo = 'FAT'
		IF @Tipo = 'Remessa'
			Set @Tipo = 'RA'
		

insert into LOG_BLS values('I',getdate(),@JOB,@Tipo,@DataInicial,@DataFinal)
--Contabilidade conforme DA.
If @TIPO = 'DA'
	Begin
		EXEC dbo.spATL_BLSTXT_TST_Sel @JOB,@DataInicial,@DataFinal
	End
--Emitida Nota de Debito para o Consignee (USD  + BRL + EUR)

--Else IF @Tipo = 'FATURA'
--	Begin
--		EXEC dbo.spATL_BLSTXTFAT_Sel @JOB,@DataInicial,@DataFinal
--	End	
--Registrado a Ordem de Compra contra o Agente
Else IF  @Tipo = 'AGT'
	Begin
		EXEC dbo.spATL_BLSTXTAGT_Sel @JOB,@DataInicial,@DataFinal
	End

	else IF  @Tipo = 'FAT'
			Begin 
				EXEC dbo.spATL_BLSTXTFAT_Sel @JOB,@DataInicial,@DataFinal
			End
		else IF @Tipo = 'FATURA - Cancelada'
			Begin 
				EXEC dbo.spATL_BLSTXTFATCancel_Sel @JOB,@DataInicial,@DataFinal
			End
		else
			Begin
				EXEC dbo.spATL_BLSTXTPROV_Sel @JOB,@Tipo,@DataInicial,@DataFinal
			End

insert into LOG_BLS values('F',getdate(),@JOB,@Tipo,@DataInicial,@DataFinal)
GO
