SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spAXReenvioXML_Teste_Sel] 1
--[spAXReenvioXML_Sel] 0
--03/11/2021  - Cadu, rotina estava desativada, alterei para enviar os casos sem ax doc xml new com I.Cd_Tp_tx diferente de ('000.1')
CREATE procedure [dbo].[spAXReenvioXML_Sel]
(
	@Type bit
)
as

declare @mes as int

--declare @Type bit
--set @Type =0


if @Type = 0 
begin
	set @mes =
	(
	select 
	case when month(getdate()) = 1  and month(getdate()-20) = 12
	then 1
	else (month(getdate()-20))
	End as teste
	)
end

--If @Type = 1
--Begin
--	set @mes =
--	(
--	select 
--	case when month(getdate()) = 1  and month(getdate()-10) = 12
--	then 1
--	else month(getdate()-10) 
--	End as teste
--	)
--end

--print @mes

if @Type = 0 
	Begin
		select 
			I.DC,I.id_Ax,moeda,tipo,I.cd_Tp_Tx_ATL,I.Num_Proc,
			AX.Dt_Envio_AX,I.Cd_Tp_tx, TT.nome_tp_tx 
		from AX_DOC_ITEM I with(nolock)
		left join AX_DOC_XML_New X with(nolock) on I.ID_AX = X.ID_AX and I.Num_Proc = X.Num_Proc 
			and I.Cd_Tp_tx_ATL = X.Cd_Tp_tx_ATL and I.DC = X.DC --and Cancel = 0 
		join AX_DOC AX with(nolock) on I.ID_AX = AX.ID_AX
		join Tipo_Taxa TT on TT.cd_tp_tx = I.Cd_Tp_tx_ATL
		join Exchange_JMD_AX_ATL E with(nolock) on  I.Num_Proc = E.Num_Proc
		where  
			X.ID_AX is null 
			and (
				month(convert(Datetime,AX.Dt_Envio_AX,105))>=@mes
			and 
				year(convert(Datetime,AX.Dt_Envio_AX,105))=year(getdate())
				--or
				--	(
				--		AX.ID_AX =829379
				--	)
			) 			 
			and I.Valor >0 and cd_pessoa_Ax is not null 
			and I.cd_tp_TX is not null
			and I.Cd_Tp_tx not in ('000.1')
		order by 
			--I.Num_Proc
			AX.Dt_Envio_AX
	End

--If @Type = 1
--Begin
--	select I.DC,I.id_Ax,moeda,tipo,I.cd_Tp_Tx_ATL,I.Num_Proc from AX_DOC_ITEM I with(nolock)
--		left join AX_DOC_XML X with(nolock) on I.ID_AX = X.ID_AX and I.Num_Proc = X.Num_Proc and I.Cd_Tp_tx_ATL = X.Cd_Tp_tx_ATL and I.DC = X.DC and X.cancel = 0 
--		left join AX_DOC_XML XC with(nolock) on XC.ID_AX = X.ID_AX and XC.Num_Proc = X.Num_Proc and XC.Cd_Tp_tx_ATL = X.Cd_Tp_tx_ATL and XC.DC = X.DC and XC.cancel = 1 
--		join AX_DOC AX with(nolock) on I.ID_AX = AX.ID_AX 
--		join Exchange_JMD_AX_ATL E with(nolock) on  I.Num_Proc = E.Num_Proc
--	where  
--		XC.ID_AX is null 
--		and X.ID_AX is not null 
--		and 
--		(
--			(month(convert(Datetime,AX.Dt_Envio_AX,105))>=@mes
--			and year(convert(Datetime,AX.Dt_Envio_AX,105))=year(getdate()))
--			or
--			(
--				AX.ID_AX =430555
--			)
--		) 
--		and Dt_Canc  is not NULL and dt_Canc_AX is not null 
--		and I.Valor >0 and cd_pessoa_Ax is not null and cd_tp_TX is not null
--End




		


GO
