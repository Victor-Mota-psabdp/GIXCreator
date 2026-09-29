SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[spSaidaReportManagerCusto_Rel] --'IM'

	@Modal	Char(2)
AS
/* 2010-12-03 retirado sum() e colocado no group by cd_pedido,cd_produto para casos de 2 itens e mesmo produto do mesmo pedido ex: job IASLA20101100801 causava cartesiano e dobrava o valor do custo
select 
	Num_Proc, sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'AFRMM%')) AFRMM, 
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'ICMS%')) ICMS,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'THC%')) THC,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Desova%')) Unload,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Armazenagem%')) Armazenagem,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Demurrage%')) Demurrage,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Desconsolida%')) Desconsolidacao,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'ISPS%')) ISPS,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Despacho%') +dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Prestados%') ) Desembaraço,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Imposto de Importaç%')) ImpostoImportacao,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Frete Interno%')) FreteInterno,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Seguro%')) Seguro,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'IPI%')) IPI,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Frete') + dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Frete (ALL IN)') + dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Fretes - CHB'))  FreteInternacional,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Cofins%')) Cofins,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Liberação de BL%')) BLFee,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Lavagem%')) Lavagem_Container,
	sum(dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'PIS%')) PIS,
	cd_proc_cliente ProdID
*/

select
	Num_Proc, 
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'AFRMM%') AFRMM, 
	0 AFRMM,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'ICMS%') ICMS,
	0 ICMS,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'THC%') + dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'capatazias%') THC,
	0 THC,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Desova%') Unload,
	0 Unload,
--	dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Armazenagem%')+dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Estadia%') Armazenagem,
	0 Armazenagem,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Demurrage%') Demurrage,
	0 Demurrage,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Desconsolida%') Desconsolidacao,
	0 Desconsolidacao,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'ISPS%') ISPS,
	0 ISPS,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'DESPACHO') Desembaraço,
	0 Desembaraço,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Imposto de Importaç%') ImpostoImportacao,
	0 ImpostoImportacao,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Frete Interno%') +dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Inland%') FreteInterno,
	0 FreteInterno,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Seguro%') Seguro,
	0 Seguro,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'IPI%') IPI,
	0 IPI,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Frete') + dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Frete (ALL IN)') + dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Fretes - CHB') FreteInternacional,
	Null FreteInternacional,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Cofins%') Cofins,
	0 Cofins,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Liberação de BL%') BLFee,
	0 BLFee,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Lavagem%') Lavagem_Container,
	0 Lavagem_Container,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'PIS%') PIS,
	0 PIS,
	cd_proc_cliente ProdID,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Posicionamento%') Posicionamento,
	0 Posicionamento,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Pesagem%') Pesagem,
	0 Pesagem,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'CPMF%') CPMF,
	0 CPMF,
	0.00 Siscomex,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'Agency%') AgencyFee,
	0 AgencyFee,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'% INAL %') Int_INAL,
	0 Int_INAL,		
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'% SENAZA %') Int_SENAZA,
	0 Int_SENAZA,
	--dbo.fBusca_Custo_Produto(Num_PRoc,cd_produto,'%Antidumping%') Antidumping
	0 Antidumping

from 
	pedido_ship PS with(nolock)
	Join PRoduto_Cliente PC with(nolock) on PC.cd_prod=ps.cd_produto
where
	num_proc collate SQL_Latin1_General_CP1_CI_AS in 
	(
	select distinct Job_Number from Sistema_Exchange_Custo with(nolock)
	Where dt_leitura is null and left(job_number,2)=@Modal
	group by job_number
	) /*and num_proc in ('IMFMC201512021BR',
'IMFMC201512023BR',
'IMFMC201512035BR',
'IMFMC201512036BR',
'IMFMC201512037BR',
'IMFMC201602007BR',
'IMFMC201602008BR',
'IMFMC201602009BR',
'IMFMC201602010BR',
'IMFMC201602011BR',
'IMFMC201602012BR',
'IMFMC201602013BR',
'IMFMC201602014BR')*/
Group by 
	Num_Proc,cd_proc_cliente,cd_produto












GO
