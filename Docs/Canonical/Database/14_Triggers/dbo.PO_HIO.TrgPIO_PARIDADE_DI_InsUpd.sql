SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create TRIGGER [dbo].[TrgPIO_PARIDADE_DI_InsUpd] ON [dbo].[PO_HIO] 
FOR INSERT,UPDATE
AS
	declare @Temp1 varchar(5000)
	
	Declare @Processo varchar(16)
	Select @Processo = Num_Proc_HIO from inserted 
	
	Declare @ID_DC as int
	Select @ID_DC= id_dc from inserted
	
	Declare @Data_PO_HIM as Datetime
	select @Data_PO_HIM = Data_PO_HIO from inserted
	
	Declare @Cd_Usuario as varchar(10)
	select @Cd_Usuario = cd_usuario from inserted
	
			
	if (@id_dc = 5)	
		BEGIN
			Declare @MSG Varchar(2000)
			DEclare @data datetime	
			set @data = (select GETDATE())
			
			DECLARE @PARIDADE AS varchar(25)
			--set @PARIDADE = (select CAST(REPLACE(cast(dbo.verparidade(convert(varchar(10),@Data_PO_HIM,103),'USD','XXX')as float),'.',',')AS VARCHAR(30)))
			set @PARIDADE = (select CAST(REPLACE(cast(Par_Moeda AS float),'.',',') AS VARCHAR(25)) From Paridade Where Dt_Par =  dbo.strhoje(@Data_PO_HIM) and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
			Declare @campo_dados as varchar(30)
			set @campo_dados = 'Paridade Dolar D.I.'
			IF cast(REPLACE(@PARIDADE,',','.') AS FLOAT) > 1
				BEGIN	
					BEGIN			
						set @Temp1 = 'dbo.[spATL_CamposAdicionais_InsUpd]'+ ''''+ @Processo + ''',''' + @campo_dados + ''','''+ @PARIDADE + ''','''+ @Cd_Usuario+ ''''
						EXEC  (@Temp1)
					END
					--exec dbo.[spATL_CamposAdicionais_InsUpd] @Processo, @campo_dados, @PARIDADE, @Cd_Usuario					
					BEGIN
						Set @MSG=('Paridade Dolar D.I. : ' + @PARIDADE + ' Data: ' + convert(varchar(10),@Data_PO_HIM,103))
						exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR',@MSG,@data,null ,'ATL System','N','U',null 	
					END
				END								
		END		
	

GO
ALTER TABLE [dbo].[PO_HIO] ENABLE TRIGGER [TrgPIO_PARIDADE_DI_InsUpd]
GO
