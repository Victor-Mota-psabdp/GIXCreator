SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT Peso_Cubado_Lea,* FROM LLP_EXP_AER Where Num_Proc_Lea='EAATL202207001BR'
--SELECT Peso_Bruto_hea,* FROM House_EXP_AER Where Num_Proc_hea='EAATL202207001BR'
--DECLARE @FirstJobChild varchar(20)
--SET @FirstJobChild=(Select top 1 Num_Proc_MEA from House_Exp_Aer where Num_Proc_HEA ='EAATL202207001BR')
--select * from Hist_geral_sistema where hsgProcesso = 'EAATL202208013BR' order by hsgdata
--select * from Hist_geral where hsgProcesso = 'EAATL202208013BR' order by hsgdata
--[spPeso_Cubado_Lea_Upd]'EAATL202208013BR'
CREATE PROCEDURE [dbo].[spPeso_Cubado_Lea_Upd]--'EAATL202207001BR'
(
	@Num_Proc_HEA	varchar(16)
)
AS

BEGIN TRANSACTION

Declare @Peso_Cubado decimal(9, 3)
Declare @Peso_Bruto decimal(9, 3)
Declare @MSG Varchar(400)

BEGIN	
	Set @Peso_Bruto = (SELECT Convert(decimal(9, 3),Peso_Bruto_hea) FROM House_EXP_AER Where Num_Proc_hea=@Num_Proc_HEA)	
	Set @Peso_Cubado = (select Convert(decimal(9, 3),[dbo].[fBusca_Volumes_M3] (@Num_Proc_HEA)))	
	IF EXISTS(SELECT Num_Proc_hea FROM House_EXP_AER Where Num_Proc_hea=@Num_Proc_HEA and @Peso_Cubado > @Peso_Bruto)
		BEGIN
			UPDATE LLP_EXP_AER SET Peso_Cubado_Lea = @Peso_Cubado WHERE	Num_Proc_Lea = @Num_Proc_HEA
			set @MSG=('Peso_Cubado_Lea updated to fBusca_Volumes_M3 : ' +  convert(varchar(25),@Peso_Cubado) + ' spPeso_Cubado_Lea_Upd - Historic created by ATL System')
			exec spHistG_InsUPD @Num_Proc_HEA,Null,Null,'Alteração no BL / AWB / HBL',@MSG,'01-01-2010',Null,'ATL System','N','S',Null
		END	
	Else
		BEGIN
			UPDATE LLP_EXP_AER SET Peso_Cubado_Lea = @Peso_Bruto WHERE Num_Proc_Lea = @Num_Proc_HEA		
			set @MSG=('Peso_Cubado_Lea updated to Peso_Bruto : ' +  convert(varchar(25),@Peso_Bruto) + ' spPeso_Cubado_Lea_Upd - Historic created by ATL System')
			exec spHistG_InsUPD @Num_Proc_HEA,Null,Null,'Alteração no BL / AWB / HBL',@MSG,'01-01-2010',Null,'ATL System','N','S',Null
		END	
END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION

GO
