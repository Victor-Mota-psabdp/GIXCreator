SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select fatcod from vwFaturas_CHB_Validas where Num_Proc = 'IMSYN201503001BR'
--spVerificaCancelaFatura_Sel 'IMSYN201503001BR','THC - 20ft','D'

--select * from vwFaturas_CHB_Validas where Num_Proc = 'IOSIK201508002BR' and Cd_Tp_Tx = 'XMU'
--select * from Cta_Cte_Hou_Imp_Out where num_proc_hio = 'IOSIK201508002BR' and Cd_Tp_Tx = 'XMU'
--select * from Tipo_Taxa where Cd_Tp_Tx = 'XMU'
--select * from Fatura_CHB where Processo_PC = 'IOSIK201508002BR'
--select * from 
--update Fatura_CHB_Item set DC = 'C' where Fatura_CC = 'IOSIK201508002BRA' and Cd_Tp_Tx = 'XMU'
CREATE procedure [dbo].[spVerificaCancelaFatura_Sel]--'IOSIK201508002BR','Multa 1 - CHB','C'
(
	@Num_Proc as varchar(16),
	@Nome_Tp_Tx as varchar(50),
	@DC	as varchar(1)
)
as
	
Declare @Cd_Tp_Tx as varchar(3)
Declare @UltimaFatura varchar(50)

Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with(nolock) where nome_tp_tx = @Nome_Tp_Tx)

select fatcod Fatura from vwFaturas_CHB_Validas CHB 
where Num_Proc = @Num_Proc and cd_tp_tx = @Cd_Tp_Tx and DC = @DC




--Set @UltimaFatura = (Select max(Fatura_PC) Fatura from Fatura_CHB FAT 
--		join Fatura_CHB_Item I on I.fatura_cc = Fat.Fatura_PC
--	where FAT.Processo_PC = @Num_Proc 
--		and I.cd_tp_tx = @Cd_Tp_Tx and Status_PC = 'E' and Cd_Tipo = 'P')


GO
