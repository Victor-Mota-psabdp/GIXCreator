SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create TRIGGER [dbo].[TrgPIM_PARIDADE_DI_InsUpd] ON [dbo].[PO_HIM] 
FOR INSERT,UPDATE
AS
	declare @Temp1 varchar(5000)
	
	Declare @Processo varchar(16)
	Select @Processo = num_proc_him from inserted 
	
	Declare @ID_DC as int
	Select @ID_DC= id_dc from inserted
	
	Declare @Data_PO_HIM as Datetime
	select @Data_PO_HIM = Data_PO_HIM from inserted
	
	Declare @Cd_Usuario as varchar(10)
	select @Cd_Usuario = cd_usuario from inserted	
			
	if (@id_dc = 5)	
		BEGIN
			Declare @MSG Varchar(2000)
			DEclare @data datetime	
			set @data = (select GETDATE())			
			DECLARE @PARIDADE AS varchar(25)
			
			--Set @Paridade = IsNull((Select Par_Moeda From Paridade Where Dt_Par = dbo.strhoje(@DtRefer) and Cd_Tp_Par = @TpPar and Cd_Tp_Moeda = @Moeda  ), 0)
			--set @PARIDADE = (select CAST(REPLACE(cast(dbo.verparidade(convert(varchar(10),@Data_PO_HIM,103),'USD','XXX')as float),'.',',')AS VARCHAR(30)))
			set @PARIDADE = (select CAST(REPLACE(cast(Par_Moeda AS float),'.',',') AS VARCHAR(25)) From Paridade Where Dt_Par =  dbo.strhoje(@Data_PO_HIM) and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
			Declare @campo_dados as varchar(30)
			set @campo_dados = 'Paridade Dolar D.I.'
			IF cast(REPLACE(@PARIDADE,',','.') AS FLOAT) > 1
				BEGIN	
					BEGIN			
						set @Temp1 = 'dbo.[spATL_CamposAdicionais_InsUpd]'+ ''''+ @Processo + ''',''' + @campo_dados + ''','''+@PARIDADE + ''','''+ @Cd_Usuario+ ''''
						EXEC  (@Temp1)
					END
					--exec dbo.[spATL_CamposAdicionais_InsUpd] @Processo, @campo_dados, @PARIDADE, @Cd_Usuario					
					BEGIN
						Set @MSG=('Paridade Dolar D.I. : ' + @PARIDADE + ' Data: ' + convert(varchar(10),@Data_PO_HIM,103))
						exec dbo.[spHistG_InsUPD] @Processo,Null ,Null,'CSR',@MSG,@data,null ,'ATL System','N','U',null 	
					END
				END								
		END	
	
	
--SELECT * FROM Paridade WHERE Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD'	
--23/04/2018	USD	XXX	3.123400
--select * from PO_HIM where Num_Proc_HIM = 'IMARB201712002BR' and id_dc = 5
--Declare @Processo varchar(16)
--set @Processo ='IMARB201712002BR'
--Declare @Data_PO_HIM as Datetime
--set @Data_PO_HIM =(select Data_PO_HIM from PO_HIM where Num_Proc_HIM = 'IMCSR201712559BR' and id_dc = 5)
--Declare @Cd_Usuario as varchar(10)
--set @Cd_Usuario ='ce'
--Declare @campo_dados as varchar(30)
--set @campo_dados = 'Paridade Dolar D.I.'
--DECLARE @PARIDADE AS varchar(25)
--set @PARIDADE = (select CAST(REPLACE(cast(Par_Moeda AS float),'.',',') AS VARCHAR(25)) From Paridade Where Dt_Par = dbo.strhoje(@Data_PO_HIM) and Cd_Tp_Par = 'XXX' and Cd_Tp_Moeda = 'USD')
--print @PARIDADE

--IF cast(REPLACE(@PARIDADE,',','.') AS FLOAT) > 1
--	declare @Temp1 varchar(5000)
--	set @Temp1 = 'dbo.[spATL_CamposAdicionais_InsUpd]' 
--			+ ''''+ @Processo + ''',''' + @campo_dados 
--			+ ''',''' +	@PARIDADE  + ''',''' + @Cd_Usuario
--			+ ''''

--	print  (@Temp1)


--(select CAST(REPLACE(cast(dbo.verparidade(convert(varchar(10),'2018-01-17 00:00:00.000',103),'USD','XXX') as float))
--(select CAST(REPLACE(cast(dbo.verparidade(convert(varchar(10),'2018-01-17',103),'USD','XXX')as float),'.',',')AS VARCHAR(30)))
--select * from Hist_Geral where HSGProcesso = 'IMCSR201712559BR' ORDER BY HSGData
--select * from Campo_Processo where Num_Proc = 'IMCSR201712559BR' and id_campo =172	

--exec dbo.[spATL_CamposAdicionais_InsUpd]@Processo, @campo_dados,@PARIDADE,@Cd_Usuario
	
	
		
		
		
		
		
		
		
	
GO
ALTER TABLE [dbo].[PO_HIM] ENABLE TRIGGER [TrgPIM_PARIDADE_DI_InsUpd]
GO
