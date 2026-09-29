SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spReportFaturamentoDetalhado_CNPJ_Sel] 
	
as

select distinct substring(num_cpf_cnpj,1,2) + '.' + substring(num_cpf_cnpj,3,3) + '.' + substring(num_cpf_cnpj,6,3)
+ '/' + substring(num_cpf_cnpj,9,4) + '-' + substring(num_cpf_cnpj,13,2)   cnpj
from Pessoa where 
	(
		apelido like 'DOW%'			or 
		apelido like 'ROHM AND%'	or 
		apelido like 'PALMYRA%'		or 
		apelido like 'PERFORMANCE - 3873C%') and desat_pes = 'N'
and len(replace(replace(num_cpf_cnpj,'_',''),' ','')) = 14
and num_cpf_cnpj not in ('06043535100201','47180625000146','47180625001975','47180625002009'
,'47180625002190','47180625002270','47180625002351')
order by 1



--'60.435.351/0047-30',
--'60.435.351/0005-80',
--'60.435.351/0025-24',
--'60.435.351/0001-57',
--'60.435.351/0003-19',
--'60.435.351/0053-88',
--'60.435.351/0017-14',
--'60.435.351/0020-10',
--'60.435.351/0021-09',
--'60.435.351/0046-59',
--'60.435.351/0022-81',
--'60.435.351/0024-43',
--'60.435.351/0011-29',
--'53.877.627/0012-44',
--'53.877.627/0013-25',
--'53.877.627/0001-91',
--'53.877.627/0007-87',
--'53.877.627/0009-49',
--'53.877.627/0002-72',
--'53.877.627/0014-06',
--'61.204.657/0001-65',
--'04.872.297/0001-36',
--'04.872.297/0016-12',
--'26.355.738/0002-46',
--'00.310.651/0003-40',
--'00.310.651/0001-88',



















GO
