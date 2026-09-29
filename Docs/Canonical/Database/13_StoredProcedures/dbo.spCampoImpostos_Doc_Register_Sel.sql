SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCampoImpostos_Doc_Register_Sel]--'A',''

@CdSite char(1),
@ID varchar(10)


as
SET NOCOUNT ON



Declare @Base_Temp decimal(18,2)
Declare @strSQL nVarchar(200)
Declare @ID_TEMP int

Declare @TAB Table
		(
			[ID_Imposto] int,
			[Imposto] varchar(50),
			[Aliq] decimal(18,2),
			[Tab_Relacionada] varchar(50),
			[Campo_Retorno] varchar(50),
			[Valor] decimal(18,2),
			[Base] decimal(18,2),
			[strSql] varchar(200)
		)
		

Insert into @TAB
	select TI.ID_Imposto,TI.Descr_Imposto, Aliq, Tab_Relacionada, Campo_Retorno, Valor, Base, NULL  from Tipo_Impostos_Doc_Register TI
	Left Join Campo_Impostos_Doc_Register CI on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto  and CI.ID = @ID
	where TI.Cd_Site = @CdSite



Declare cTemp cursor for
	Select ID_Imposto from @TAB
Open cTemp
		Fetch next From cTemp into @ID_TEMP
			While @@FETCH_STATUS=0
				Begin
					update @TAB Set strSQL = (select 'Select @Base_Temp = ' + Campo_Retorno + ' From ' + Tab_Relacionada + ' where ' + 'ID = ' +''''+ @ID +''''+ ' and Ref_Acesso = ' +''''+ @CdSite + ''''   from @TAB where ID_Imposto = @ID_TEMP) --group by Campo_Retorno,Tab_Relacionada)
					Set @strSQL = (Select strSQL from @TAB where ID_Imposto = @ID_TEMP)
					EXEC SP_EXECUTESQL @strSQL, N'@Base_Temp decimal(18,2) OUTPUT',@Base_Temp OUTPUT
					Update @TAB set Base = @Base_Temp where ID_Imposto = @ID_TEMP
					fetch next From cTemp into @ID_TEMP
				End
close CTemp
deallocate CTemp

--print @strSQL
--set @Base_Temp =
 --exec (@strSQL)
Update @TAB set Valor = convert(decimal(18,2),([Base]*[Aliq])/100) --where Valor is NULL
 --select * from @TAB
 select ID_Imposto,Imposto, Base, Aliq, Valor  from @TAB

--select top 1 * from Base_Nota_Fiscal

--exec select * from tipo_Impostos

--exec 'select * from Pessoa'
GO
