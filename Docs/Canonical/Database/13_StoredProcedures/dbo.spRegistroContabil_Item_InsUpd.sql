SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido pra fazer o id_item na stored, antes era na tela - 11/06/2014 - Cadu
--select * from Registro_Financeiro where ano = 2014 and  mes = 06 and num_registro = 000174
--select * from Registro_Financeiro_Item where ano = 2014 and  mes = 06 and num_registro = 000174
--select * from vwcta_cte where num_proc_hia = 'EMOXT201405111BR'
--select * from tipo_taxa where cd_tp_tx = 'BRO'

--cadu - 27-12-15 - incluido pra ser varchar(3), pq tem registros com 3 digitos
--cadu 02/11/2022 - @IDItem		varchar(10), e numero com 5 caracteres
--[spRegistroContabil_Item_InsUpd] '06', '2014', '000174','01','EMOXT201405111BR','D','Serviços de Despacho 1','',150.00,0.00,150.00
CREATE procedure [dbo].[spRegistroContabil_Item_InsUpd]

	@Mes		int,
	@Ano		int,
	@Registro	varchar(6),
	@IDItem		varchar(10),
	@JOB		varchar(16),
	@DC			varchar(1),
	@Taxa		varchar(50),
	@Conta		varchar(13),
	@Valor		float,
	@ValorIVA	Float,
	@ValorTotal	Float

	as

	Declare @Cd_Taxa varchar(3)
	Declare @ContaContabil varchar(13)

	Set @Cd_Taxa = (select top 1 cd_tp_tx from tipo_taxa where nome_tp_tx = @Taxa)
	Set @ContaContabil=(select top 1 cd_CtA_ctb from cta_ctb where cd_cta_ctb_red=@Conta)

	IF not exists (select Id_Item from Registro_Financeiro_Item where Num_Proc =@JOB and Cd_Tp_Tx=@Cd_Taxa and
					DC=@DC and mes=@Mes and ano=@Ano and num_registro=@Registro)
				Begin
					set @IDItem =(select isnull(right('00000' + convert(varchar(5),max(convert(int,Id_Item)) + 1),5),'00001') from Registro_Financeiro_Item where mes=@Mes and ano=@Ano and num_registro=@Registro)
				End
	ELSE
				Begin
					set @IDItem = (select Id_Item from Registro_Financeiro_Item where Num_Proc =@JOB and Cd_Tp_Tx=@Cd_Taxa and
					DC=@DC and mes=@Mes and ano=@Ano and num_registro=@Registro)				
				End
		

	if exists (select * from Registro_Financeiro_Item where mes=@Mes and ano=@Ano and num_registro=@Registro and id_item=@IDItem) 
		begin
			update
				Registro_Financeiro_Item
			set
				Valor=@Valor,
				Cd_Cta_Ctb=@ContaContabil,
				Num_Proc=@JOB,
				Cd_Tp_Tx=@Cd_Taxa,
				DC=@DC,
				Valor_Iva=@ValorIVA,
				Valor_Total=@ValorTotal
			where
				mes=@Mes and ano=@Ano and num_registro=@Registro and id_item=@IDItem
		end
	else
		begin
			insert into
				Registro_Financeiro_Item
				(
				Mes,
				Ano,
				Num_Registro,
				ID_Item,
				Valor,
				Cd_Cta_Ctb,
				Num_Proc,
				Cd_Tp_Tx,
				DC,
				Valor_IVA,
				Valor_Total
				)
			values
				(
				@Mes,
				@Ano,
				@Registro,
				@IDItem,
				@Valor,
				@ContaContabil,
				@JOB,
				@Cd_Taxa,
				@DC,
				@ValorIVA,
				@ValorTotal

				)
		end


--Atualizar campos totais do Registro Financeiro

Declare @Total Decimal(10,2)
Declare @IVA	Decimal(10,2)
Declare @TotalDoc Decimal (10,2)



select @Total = sum(dbo.valor(valor,dc))*-1  ,@IVA= sum(dbo.valor(isnull(valor_IVA,0),dc))*-1 , @TotalDoc= sum(dbo.valor(isnull(valor_total,0),dc))*-1  from Registro_Financeiro_Item where mes=@Mes and ano=@Ano and num_registro=@Registro

Update Registro_Financeiro set Total=@Total, IVA_Retencoes=@IVA,Total_Doc=@TotalDoc where mes=@Mes and ano=@Ano and num_registro=@Registro


	--IF @@Error <> 0
	--		BEGIN
	--			ROLLBACK TRANSACTION
	--			RETURN -1
	--		END






GO
