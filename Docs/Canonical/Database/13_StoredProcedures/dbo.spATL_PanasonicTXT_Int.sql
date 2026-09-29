SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_PanasonicTXT_Int] 'IAPNS201407001BR','2014-07-01','2014-07-23'
CREATE Procedure [dbo].[spATL_PanasonicTXT_Int]
	 
	@JOB varchar(16),
	@DataInicial datetime,
	@DataFinal datetime
as
 
Declare @Table Table
	(
		Cd_tp_Tx varchar(3),
		Descricao Varchar(20)
		)
		
insert @Table values('BRO','Com. Despachante     ')
		
insert @Table values('DES','Taxa desconsolidação')
insert @Table values('FRT','Frete Inter. Collect')

insert @Table values('ICM','ICMS')
insert @Table values ('XAC','ICMS')

insert @Table values('SDA','SDA')

insert @Table values('SOA','Armazenagem 1ª')
insert @Table values('XAH','Armazenagem 1ª')

insert @Table values ('XTM','Transporte Merc.')




Select	cast(isnull(hawb_hia,'') as char(20))+
		cast(isnull(left(dbo.fBusca_TipoDocCliente('N',num_proc_hia,1) ,20),'')as char(12))+
		cast(f.fatcod as char(20)) +
		cast(Descricao as char(20)) +
		cast('108565' as char(20)) + --Codigo de fornecedor fixo da BDP
		convert(varchar(10),fatdtemissao,101) + ' 00:00:00 ' +		
		convert(varchar(10),FatDtVenc,101) + ' 00:00:00 ' + ' Depósito Bancário ' +
		cast(cast(Vlr_PC as decimal(10,2)) as varchar(20))
		
		
from house_imp_aer hou
	Join Fatura_chb fat on processo_pc=num_proc_hia
	Join Fatura_chb_item FI on fatura_pc=fatura_cc and Tp_Pgto = 'B'
	Join fatura F on f.fatcod=fatura_pc	
	Join @Table T on T.cd_tp_Tx=FI.cd_tp_Tx
where num_proc_hia=@JOB 


--select * from Fatura_chb_item
--where Fatura_CC = 'IAPNS201404001BRA'  order by Tp_Pgto

--select * from Fatura_chb_item
--where Fatura_CC = 'IAPNS201407001BRA' order by Tp_Pgto
GO
