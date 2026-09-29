SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view vwPOExportBF_BO

AS

select * from po_hem
where num_proc_hem like 'EMCSR%' and id_dc=10

union

select * from po_hea
where num_proc_hea like 'EaCSR%' and id_dc=10

union

select * from po_heo
where num_proc_heo like 'EOCSR%' and id_dc=10


GO
